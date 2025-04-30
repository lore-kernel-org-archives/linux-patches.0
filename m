Received: from e2i340.smtp2go.com (e2i340.smtp2go.com [103.2.141.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A7325A658
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 13:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.2.141.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746018028; cv=none; b=QPf1ZLN8/v4oDi5BsKpzaocEMC8gcqD2gHRXqbfy+vb9kQpzu2B3/gS6wdc4DlvdI7zLCzwoJ/SlkyrdiCZloVUcYPbbmdJ7MNKkt38RhRKTTLi4zGlcJD4sJRvO9R+gERS44sCY+D479A5V489GYuIswOXpTGP0kBKXdloB0Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746018028; c=relaxed/simple;
	bh=UfNIy3x2jjoQoRPx+gx9seJMZKBmJ3imkS+H6drHy1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFQprnCglnUsszp/25kwC4dskq0NwxKjLU9J/QheCMkri6iYIASEdAumJDnT7RdQ+fhvv6x8X9pL0/Pl54T2o11zbt2ZOnDwid29hRHTgOuwBgGiZMQg9FOGnxCc5HpKoqnak9NM5u7E1HJXxzbV86TuieXeB7vCOpBCDa9Ui0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=triplefau.lt; spf=pass smtp.mailfrom=em510616.triplefau.lt; dkim=fail (0-bit key) header.d=smtpservice.net header.i=@smtpservice.net header.b=xO2aXKAE reason="unknown key version"; dkim=pass (2048-bit key) header.d=triplefau.lt header.i=@triplefau.lt header.b=N03Nyi6C; arc=none smtp.client-ip=103.2.141.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=triplefau.lt
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em510616.triplefau.lt
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="unknown key version" (0-bit key) header.d=smtpservice.net header.i=@smtpservice.net header.b="xO2aXKAE";
	dkim=pass (2048-bit key) header.d=triplefau.lt header.i=@triplefau.lt header.b="N03Nyi6C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=smtpservice.net; s=maxzs0.a1-4.dyn; x=1746018926; h=Feedback-ID:
	X-Smtpcorp-Track:Message-ID:Subject:To:From:Date:Reply-To:Sender:
	List-Unsubscribe:List-Unsubscribe-Post;
	bh=O+2SKE6Xcv8x1uf3Am8vN4RBUrgGMfKxPGi0oSJmOAI=; b=xO2aXKAEiDXkcvgZDCPKjv6oVl
	KbYsYiLxHg2rDrP2amdYvzY/rP9tsIlapBJ/AdqtXJ0IXQjlMI+boeN1vapcCDF8luleonqaCOfHr
	cSs2KHUnpg95NGNZ4Dfl6VewWwsCrwBLiy1q/NY3wFZWqrL2m3GSFL4QzLfniaPSyOLbN1Er5ip08
	iA44jwqCp+q8mYYYPrVFoddKHGkiPRPIitoFLOuFKiLufHdwnclxJp+mIqagSpTh96lZXmZM0LLU2
	/G9S/0rYvdByLQY5yZPvH8jZjEi21CIutqMCW/xeIAetxRTlx7Bx8jtURLED6SHf+NYEMpo96bd5k
	8ITQqtlQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triplefau.lt;
 i=@triplefau.lt; q=dns/txt; s=s510616; t=1746018026; h=from : subject
 : to : message-id : date;
 bh=O+2SKE6Xcv8x1uf3Am8vN4RBUrgGMfKxPGi0oSJmOAI=;
 b=N03Nyi6CRP/X8wA6YjiD+xXjznrvRngEJUDhJygF+QzPGI/DNuBnPY45Pat72VypWhC9c
 jQ2MdzmFnMZpMfK69QVwAaqPVYaPcT60KDuaTXP4pIauo7sj/F+H8tHuBeQ1LXNOSoHjtc/
 ztm1gOh6zV0dV1f7A16KkoPxuyuQv6HicY66mOjezRfUsMeqCXBfp5F0hmQlp1gMAGNBOt+
 zi+REruN90iI42v31FMg6ZUp3saYvfumcCIU9RSD42SDawPo66p1chQ2AZuO1QUwBuOGLUE
 dPGXeqC4HTO04ZP7LqTYqWeGKrQ3YCCjr7AF6EdBGQdvfWOnWx940GhgHwQg==
Received: from [10.172.233.58] (helo=SmtpCorp) by smtpcorp.com with esmtpsa
 (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
 (Exim 4.94.2-S2G) (envelope-from <repk@triplefau.lt>)
 id 1uA72t-TRk73a-Ae; Wed, 30 Apr 2025 13:00:15 +0000
Received: from [10.12.239.196] (helo=localhost) by smtpcorp.com with esmtpsa
 (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
 (Exim 4.97.1-S2G) (envelope-from <repk@triplefau.lt>)
 id 1uA72t-FnQW0hQ0MaB-kGqs; Wed, 30 Apr 2025 13:00:15 +0000
Date: Wed, 30 Apr 2025 14:53:00 +0200
From: Remi Pommarel <repk@triplefau.lt>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Johannes Berg <johannes.berg@intel.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 128/373] wifi: mac80211: Update skbs control block
 key in ieee80211_tx_dequeue()
Message-ID: <aBIdLC9e4BR1U6mm@pilgrim>
References: <20250429161123.119104857@linuxfoundation.org>
 <20250429161128.436695769@linuxfoundation.org>
 <aBHkJ0v5UnXPlRWl@pilgrim>
 <2025043032-herself-rendition-b721@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025043032-herself-rendition-b721@gregkh>
X-Smtpcorp-Track: AxtApIgs0QGl.HllVBAgUxsVJ.sfNjiQhS-SI
Feedback-ID: 510616m:510616apGKSTK:510616susjtUlcmQ
X-Report-Abuse: Please forward a copy of this message, including all headers,
 to <abuse-report@smtp2go.com>

On Wed, Apr 30, 2025 at 11:16:47AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 30, 2025 at 10:49:43AM +0200, Remi Pommarel wrote:
> > Hello,
> > 
> > On Tue, Apr 29, 2025 at 06:40:05PM +0200, Greg Kroah-Hartman wrote:
> > > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > This patch should not be included in any stable version.
> 
> Why not?  It is documented to fix a bug, is that not correct?

This has been reverted later on as it introduced a regression in
mediatek driver.

But I missed that you also queued the revert for stable. So false alarm
here, you can keep the commit and its revert for stable or drop the two;
both scenario are fine with me.

Thanks.

-- 
Remi
