Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E5EEEB3;
	Sat,  6 Dec 2025 21:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765055486; cv=none; b=ojs+1MW/KhYZEFkxBCUMrUyREgdXYC7Rb6ONZUeq1JTZXWF8uQCm9XEE5kBMmGSTCBQFt6rM0oN7A6f41evKDkJqkg2DxIGJNFOaXYj8vRwovGrQbXp/NHadQFSb+dqkDXblffUJ1mCAcSnMV0Phr5QbUZZppsgOzRSM6jLDZTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765055486; c=relaxed/simple;
	bh=3HV0mr7oIZvawRTMKXqkblIV1Io1yttrUfiUmN7U3+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gs3FkPCn/4OmKCaiLT1BFlpgbUOGxaWxZJcrr3lC4S48V95KKNzBT/oWvZdUk5Ujv2m3LAo1QRiFHqNgFoPth22kTfhkqawX8DTmRH3XQCSQB/si4gphiMCwX0HherFHISI5886Wy99n5Uffysxv+2obevezVJQ5njcG3+xaouc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sd64rUId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sd64rUId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9A7C113D0;
	Sat,  6 Dec 2025 21:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765055486;
	bh=3HV0mr7oIZvawRTMKXqkblIV1Io1yttrUfiUmN7U3+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sd64rUId+al9Cn6FZm0G9+y7cLj8RfA7eC07KK4U+5pWz2s1wepYvbrcdflTaJJK/
	 8LPt4qZGwQHoXEftbCgUkDE9O0AodD9/9+IegEAPXoCMyMdXNcTg6+rD87ZE/MOKrg
	 9edbjEN2JTwXwIdgP/NyWzOFl4Bpk4davpnR6dJY=
Date: Sun, 7 Dec 2025 06:11:20 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6.1 414/568] scsi: ufs: core: Add a quirk to suppress
 link_startup_again
Message-ID: <2025120709-corner-puritan-90ae@gregkh>
References: <20251203152440.645416925@linuxfoundation.org>
 <20251203152455.856124103@linuxfoundation.org>
 <2fa15075-56a3-4afe-b59a-1a78f4b7f971@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fa15075-56a3-4afe-b59a-1a78f4b7f971@pobox.com>

On Thu, Dec 04, 2025 at 08:53:12AM -0800, Barry K. Nathan wrote:
> On 12/3/25 07:26, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Adrian Hunter <adrian.hunter@intel.com>
> > 
> > ufshcd_link_startup() has a facility (link_startup_again) to issue
> > DME_LINKSTARTUP a 2nd time even though the 1st time was successful.
> > 
> > Some older hardware benefits from that, however the behaviour is
> > non-standard, and has been found to cause link startup to be unreliable
> > for some Intel Alder Lake based host controllers.
> > 
> > Add UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE to suppress
> > link_startup_again, in preparation for setting the quirk for affected
> > controllers.
> > 
> > Fixes: 7dc9fb47bc9a ("scsi: ufs: ufs-pci: Add support for Intel ADL")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> > Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> > Link: https://patch.msgid.link/20251024085918.31825-3-adrian.hunter@intel.com
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> 
> This backport's commit message is missing the corresponding upstream commit
> (which is d34caa89a132cd69efc48361d4772251546fdb88).

Ah, good catch, don't know how I missed that, thanks!

greg k-h
