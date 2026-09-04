Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D0F2E8DEC;
	Fri,  4 Sep 2026 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788531160; cv=none; b=BrlbcPNck2htAK7n/mkRJ853CD1M7GTm4Y+zVCYKmUW6PnHgUH/XSObSKoduG8r8+/7zFvwFGeWm7LJwnXgXALfkJ12Ra2kSUwX0Nh+VZD+XRMlLe55rNgKOl+OJb5iER7i8WrcU8eorV5FNj/e0Xueoyeytka6j97UPqnw2GeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788531160; c=relaxed/simple;
	bh=UEWlKWPr9JXPi0SPi/EYHDoJZTTbt+OtxwtkVKc/W+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIm4WWLMb7qnY7kN4Wje3pkIMyLhJ6CK7toEdQfB6Hzrw110GaxpYQlfKsaz3i6Y1qiFe0hmdpYXing3eFajiJfZBdwG1i5LciJ6yf18Y2+d1gVbed7hjtFEZcEXvzyyhI+hpTfPmo6uM4o5JN/NA0Adxq2DWqEC2SYOZQ3RbD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KO+u9VQn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KO+u9VQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC0C1F00A3D;
	Fri,  4 Sep 2026 14:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788531158;
	bh=NQQXN7XObmy/sQCXJZB13q5gSBD0fJWt3C/4V22QsxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KO+u9VQniIXowtbYT5Ps3Z3LI0BDv1d1mZvRthzWWYtlaMTWB4TGFEk0LYJzfYHNW
	 TfPA4Nx7eZPAN2HWcw2S7RbmBNr4KyzxzxP3JPI7E43dO34bxXw/Ds/KZx3R50Z8Zm
	 4PX1R/IkacBD3eBlGjAod8VbSTvE4YA3d+a6h5EwWuSMHKnNIjojY9ZXSQWrNwsmMH
	 Bo0HA4RECWGfEut8EQyOwJEgBsmYVPgj1Ay7jZifzB66IvwmVQuevE1aVQWepxQ3v7
	 xRJrZ8B9y7ItTFVN+VggjJjbrw/BM9UnGM2sQFYnm4qiQ0bfs1JKMIxkpzW/DtqYgv
	 vpoeUUL+rVS7w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Darshit Shah <darnshah@amazon.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 7.2 532/713] PCI/DPC: Allow DPC on all Downstream Ports when OS controls AER
Date: Fri,  4 Sep 2026 10:12:32 -0400
Message-ID: <20260904133500.rc-reply-0001-pci-dpc-aer@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <apqJFWNrcajdFyad@wunner.de>
References: <20260904045803.810145556@linuxfoundation.org> <20260904045815.744991650@linuxfoundation.org> <apqJFWNrcajdFyad@wunner.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Sep 04, 2026 at 11:02:13AM +0200, Lukas Wunner wrote:
> Guixin Liu has found a problem with this upstream commit:
>
> https://lore.kernel.org/all/20260901064554.2178688-1-kanie@linux.alibaba.com/
>
> There's no fix in Linus' tree yet, so it might be best to hold off
> for now on backporting the offending commit to stable kernels.

Dropped from the 7.2, 6.18, 6.12 and 6.6 queues, thanks.

-- 
Thanks,
Sasha
