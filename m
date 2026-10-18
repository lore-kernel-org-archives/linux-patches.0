Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794484052D5
	for <patches@lists.linux.dev>; Sun, 18 Oct 2026 19:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792353007; cv=none; b=RU87LtQgPlKlQ52EIl0uFEjpN3VPj2DseuEHLkj7jfln6l+9hzLLtHZFPTvNcNLoGrv153iTnjFv04v2hxO1gT/vmMsv3VU5Xa/SdAL0CqRTXOmqUkrBR+YOu7SeuO94CUmU+7575vmrZESJRUrCp3cp6cZ2SwWbDWhpPRrZg94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792353007; c=relaxed/simple;
	bh=K7WXAtj6VcqOgXqUYGwSYxMRZ5G2Y+rU7yssblzKzYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gOnR89Bmv5JitP+rHZfQDRRMtT1WTqXdYdTbPe+cP81IVTuMHoJg+S27chy2a/QF/y9ijdfqW2AKVd4f3GJR+Ye4YwEPjptpionS+Xgx1JYyio+FkGSZ23lXHGXNVjsU4nU2jzGKE3Kq2MH593Wt5l0tA3O7le0rfPlefYanaTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ametros.net; spf=pass smtp.mailfrom=ametros.net; dkim=pass (2048-bit key) header.d=ametros.net header.i=kernel@ametros.net header.b=RQyCDaWX; arc=none smtp.client-ip=212.227.126.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ametros.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ametros.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ametros.net header.i=kernel@ametros.net header.b="RQyCDaWX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ametros.net;
	s=s1-ionos; t=1792352989; x=1792957789; i=kernel@ametros.net;
	bh=K7WXAtj6VcqOgXqUYGwSYxMRZ5G2Y+rU7yssblzKzYA=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=RQyCDaWX/W/jZhuc2CyEQK20UxPCinYCFpA08CGu2rBTYNqlS9gBg0KeGv5kTt/E
	 91eccsoWX+0cQ+zZl9pGVPZ+1DR/QC1w5F8gYWyvrmI/gZeWkB9C0AHCRGe6RzKbF
	 tOOJJQTuMLiMUZvqZw7PKzTkeqf++Mawt1Q/QxR4mNkLtXAnR2Pa3w887LDS2LlyV
	 tydXUyQ9CwhyJQ/AbXuVD5rGz7X763Z1sZg9J9ITO74sNK9HiHMuaf/g9/aGGTGE9
	 Geq2Up7k+ilMa2lJIpbaNF0GM1g9U1XCubpFz0jpx0K4G7G3kJp3g+bWrlpVF3okF
	 2nFrj+Pv1acCJyyUTw==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue011
 [213.165.67.103]) with ESMTPSA (Nemesis) id 1MeCYx-1wieAk2bX5-00nmvv; Sun, 18
 Oct 2026 21:49:49 +0200
Date: Sun, 18 Oct 2026 20:49:47 +0100
From: Bob Anderson <kernel@ametros.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wolfgang Walter <linux@stwm.de>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: regression 6.18.57: acpi power button vanished in machines
 running in qemu
Message-ID: <atUi2y2BDyrDGbpG@ametros.net>
References: <5fe757e7aa54c38df3525d313598db99@stwm.de>
 <2026101834-parchment-reps-0bee@gregkh>
 <atSdI7buRErdF1jZ@ametros.net>
 <2026101813-doorstop-hyphen-614c@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026101813-doorstop-hyphen-614c@gregkh>
X-Provags-ID: V03:K1:QTVi1O4yec0oadD44TJ0KgBN3bDxBok6eCCWpioUhgI7R1FY8UG
 zjUENgECFoL+nEGPkoUc4DyCxTcXvCicUDXQJyn0nktJulQPinOK6YAwmxVmD8Q2PPvNtou
 ADF9ZXxAnuDfR5cSpGvXcRIwDxBn6XJFDDOAl4y39Su7BacBOhPVmFyLCSfyfhgDcJ1yXCV
 2VlntU5pdDPM+c7oj6BYA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:A5bYA/jo6G8=;74gA9c1n8eo6EgAYvvq8GNivX9s
 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

On Sat, Oct 17, 2026 at 07:26:54PM +0200, Wolfgang Walter wrote:
> since 6.18.57 there is no acpi power button any more in virtual qemu based
> machines (as far as I can see model doesn't matter).

Cherry-picking ab06eb9204010c61e754bf4e71ee6f554584714d should fix things.

thanks,
Bob.
