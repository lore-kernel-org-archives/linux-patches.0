Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C78317998;
	Thu, 22 Feb 2024 08:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708590934; cv=none; b=NqL+mh0UmCbWLtjO5xRbMVS8TZ+PtA+ponpa1SmGIcMyxuTFqkNWI2qP5xjHow3/HlMinPrrjZbEH08nm2ODyuhHkr+4iTEwrkDfCZWvaBvz0pUMhohRekDym7W7219YgEgZQ5OKE6HpPSRpegAwm3RU/DHwBnriNHnuQPcRVKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708590934; c=relaxed/simple;
	bh=4MEKBoMdgYR1x9jmQ1KIYhwwWveqb3+fP/5f0Ugfsic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HQl+fW8RlXTmYETHCa4OVgPN3WLPxi9CXlDFq0naNMPSNYtk7R3G0ENKWW8libXlB4hXUaLv3fKUvtpaQf29BRXko+YCotI6IWep5aPs7blihjIOFgOWRu038BvDV+IdovbXLj5bnlf2tsS37Gj/qwrSfz9/NlywCjgqXAzpZZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1Wkm9Z0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1Wkm9Z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AF9C433C7;
	Thu, 22 Feb 2024 08:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708590933;
	bh=4MEKBoMdgYR1x9jmQ1KIYhwwWveqb3+fP/5f0Ugfsic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m1Wkm9Z0it0fXdM/Va5AppnYI+q4ksORzpgthQXzEaQDQDXee2Tpbhv038ma23LBp
	 Pf+khGaZxQTeTOVzZ40WtQamSGEDSVc+t2U/J4gosKqC/3gejx13qB8kNPoyKrIaDs
	 F31jtJJRNNIowJcBrlTpSaiCjn0E3hrt8DmHkeqA=
Date: Thu, 22 Feb 2024 09:35:31 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
	Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 350/379] mwifiex: Select firmware based on strapping
Message-ID: <2024022227-percent-wielder-3d24@gregkh>
References: <20240221125954.917878865@linuxfoundation.org>
 <20240221130005.373885693@linuxfoundation.org>
 <xxg5asor55x4yz4nvg5sn6reliefneaotvdbnl5hkvmxd3gnsr@5u3tvfhf2oyy>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xxg5asor55x4yz4nvg5sn6reliefneaotvdbnl5hkvmxd3gnsr@5u3tvfhf2oyy>

On Wed, Feb 21, 2024 at 02:20:02PM +0000, Alvin Šipraga wrote:
> On Wed, Feb 21, 2024 at 02:08:49PM +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> Same comment here as on the 5.15 review: drop patches 350 and 351.

I'll go drop them all, thanks!

greg k-h
