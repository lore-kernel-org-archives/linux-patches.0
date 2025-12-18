Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5612D3EF1;
	Thu, 18 Dec 2025 19:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766085246; cv=none; b=fXi6RoCGr28x2U93VsLywWTDSd0fTK9nIkvtHuEd+gFVMUTKZY8LSmwyTN5okpBSIpFjtRLfuICo3Ff1Er/xLOZFfqXz+0X0l59dq9lncD8yTNtEwFJW1NdIVHewCAzHogpjjSabUmtCd6WT40cVsYH1aZD5T2V55xQMq4K5/UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766085246; c=relaxed/simple;
	bh=geCkG7018qhjgyJZ056YXPFHJ9AJbInz89KQiFZLfIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rDg6YmnEIdCc7VXXEpJByX9YM5PdNbVAZEQxSNFT1dymt/LQqLUeBNjM+LQhBTX9G04gG9U5v+IqN9yfKGr/KjGc15xANkgTmVHk04SyYKnTimzEY/6/6dmvDhVRoVPHuCXKmxAAvYfAtjg3CG9TRe751Sui97HxtbMxzd2e3lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pg77mIpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pg77mIpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8869AC4CEFB;
	Thu, 18 Dec 2025 19:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766085245;
	bh=geCkG7018qhjgyJZ056YXPFHJ9AJbInz89KQiFZLfIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pg77mIpdP6Pl3SwHtZMLbogHK7UoTsKP3AoE2Fs99g+g0B+mePEecli2O6/t4Sxv9
	 w5v6WhcaeHHpuBGKlqbQ6ay/9nwkFABvdJAMzP06vmOqJahHRM65jPeiUMX4DvLYtI
	 ur2glo0iS1hHrT8k869SDU82YUN05ILgML7W0pvKxBv8RsLOF2r6epcbdC8vOjyftc
	 WGkfiHBPR+fHY1eRv/ZvKgQyOlapZ9n7S0dKJg+SqhtSN53LEuvcwlxt+movzv5tA9
	 /4T9mcuFbCp2He1rm++vsrtZj39SUfUQf2rHf1fVcb9Fo5Hn7PY+l5ToVLLS9sDcKh
	 7lhgaZhaUvQ+Q==
Date: Thu, 18 Dec 2025 19:14:04 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Michael Kelley <mhklinux@outlook.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Wei Liu <wei.liu@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Roman Kisel <romank@linux.microsoft.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.17 247/507] Drivers: hv: VMBus protocol version 6.0
Message-ID: <20251218191404.GA1749918@liuwe-devbox-debian-v2.local>
References: <20251216111345.522190956@linuxfoundation.org>
 <20251216111354.443732020@linuxfoundation.org>
 <SN6PR02MB4157943A3FE6E7BADC7DF1F2D4AAA@SN6PR02MB4157.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR02MB4157943A3FE6E7BADC7DF1F2D4AAA@SN6PR02MB4157.namprd02.prod.outlook.com>

On Tue, Dec 16, 2025 at 06:28:40PM +0000, Michael Kelley wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org> Sent: Tuesday, December 16, 2025 3:11 AM
> > 
> > 6.17-stable review patch.  If anyone has any objections, please let me know.
> 
> I don't think this patch should be backported to any stable versions. It's part
> of a large-ish patch set that implements a new feature.
> 
> Wei Liu -- is there anything going on behind the scenes that would suggest otherwise?

I agree with you, Michael. This shouldn't be backported..

Wei
