Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B702D1AB53E;
	Thu,  4 Jul 2024 09:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720085892; cv=none; b=DFHU5CMzeBsRTTxR1z7B3UkydkipCp2gyLQdqWjERdTBx9TrqQJHS/UdPYloRcB/jwsPHUdzozyOt2Stw1KU2fuw/LKP0YN+73/8jmzF0UdvxwQU9w3pnxyP85S5AePLRC8egrdlNUgrYnzniwUfjKeC2wPxG7P8f9maJ2NLBFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720085892; c=relaxed/simple;
	bh=2AF9R27GPR4mjRKVTRDK0U53lPFG2NVTk4UwvfBSw/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oma9RqU8I64c2KdQ3g9ICj91sa/9+t+Uc9Clg8DuAWKXC32rLS9mTnczc2WIObHXPxkXhme33oDtaJcD64u+PV1v7GDCNHuOnjUgAEcUbRvLLKEn5amzm01bQwwROK+mYBsLyVHuDQeeWQNEbIUUUjBLJoAVYoEEf2+H1dG2Gt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oulloxkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oulloxkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E671BC4AF0A;
	Thu,  4 Jul 2024 09:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720085892;
	bh=2AF9R27GPR4mjRKVTRDK0U53lPFG2NVTk4UwvfBSw/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OulloxkqYmbeB3pLFV7nMiqckYQPiiHdJTUpcXlqSeE4NljCEoPmIfaacE1fv84wm
	 52z8Luv2MLT0Iq4IK56fWQEDhx6g0wXt+Z3MHSTn3/fmuFrmgWhYVTNYmFEvy5ueHr
	 hlQyKSYq+E/BX9eQU7hFBO9sp8p7lNYyrmpw5VyQ=
Date: Thu, 4 Jul 2024 11:38:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 093/139] scsi: mpt3sas: Add ioc_<level> logging
 macros
Message-ID: <2024070449-tarantula-unwieldy-9b51@gregkh>
References: <20240703102830.432293640@linuxfoundation.org>
 <20240703102833.952003952@linuxfoundation.org>
 <f054ce9050f20e99afbed174c07f67efc61ef906.camel@perches.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f054ce9050f20e99afbed174c07f67efc61ef906.camel@perches.com>

On Wed, Jul 03, 2024 at 04:10:43AM -0700, Joe Perches wrote:
> On Wed, 2024-07-03 at 12:39 +0200, Greg Kroah-Hartman wrote:
> > 4.19-stable review patch.  If anyone has any objections, please let me know.
> 
> Still think this isn't necessary.
> 
> see: https://lore.kernel.org/stable/Zn25eTIrGAKneEm_@sashalap/

It's needed due to commit ffedeae1fa54 ("scsi: mpt3sas: Gracefully
handle online firmware update") which is in this series and uses the
io_info() macro.

thanks,

greg k-h
