Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D72F13B5A9
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 02:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745980892; cv=none; b=Y0WAdVEDvVAq63NV3RiuPSoG14wmp/zW8gAl9lyZuvCRBxa0R5xLU6UTqYZ7lpi1n36ypWgXV1wUoosWIPNZzFlWm2uwPkIzPx2K8jXORw2RJ+xh52zu2lsZRc2yk6YmY1suep7wogIGljAmK5Ki7LisTKtZreYZieVsS2WofAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745980892; c=relaxed/simple;
	bh=eY5lON/0VtKN+8zhZHnwDVS18HQJMNK3PU4hmkoLby4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ghnWm4jPv/4oZKLX6d//54Gz3RTDPqUKDbY22CYC0ZAGqtMFo3Us0rzsNPHkeERunipjLelrCaXpGJmJsCvWI992//j+3eCXqonXWIkRg7fJj34f26tztPZTNSb0qTI3oV+H/1T/m4Op+61Jma6/mLFwYYzgsLUYKJH6VABbbrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.98.2)
	(envelope-from <daniel@makrotopia.org>)
	id 1u9xIJ-00000000269-3ztd;
	Wed, 30 Apr 2025 02:41:27 +0000
Date: Wed, 30 Apr 2025 03:41:23 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 294/373] net: dsa: mt7530: sync driver-specific
 behavior of MT7531 variants
Message-ID: <aBGN0w1Wp1PRfPWn@makrotopia.org>
References: <20250429161123.119104857@linuxfoundation.org>
 <20250429161135.207985097@linuxfoundation.org>
 <aBEbqsJhVNaLh82G@makrotopia.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBEbqsJhVNaLh82G@makrotopia.org>

Hi again,

On Tue, Apr 29, 2025 at 07:34:21PM +0100, Daniel Golle wrote:
> On Tue, Apr 29, 2025 at 06:42:51PM +0200, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Daniel Golle <daniel@makrotopia.org>
> > 
> > [ Upstream commit 497041d763016c2e8314d2f6a329a9b77c3797ca ]
> > 
> > MT7531 standalone and MMIO variants found in MT7988 and EN7581 share
> > most basic properties. Despite that, assisted_learning_on_cpu_port and
> > mtu_enforcement_ingress were only applied for MT7531 but not for MT7988
> > or EN7581, causing the expected issues on MMIO devices.
> > 
> > Apply both settings equally also for MT7988 and EN7581 by moving both
> > assignments form mt7531_setup() to mt7531_setup_common().
> > 
> > This fixes unwanted flooding of packets due to unknown unicast
> > during DA lookup, as well as issues with heterogenous MTU settings.
> > 
> > Fixes: 7f54cc9772ce ("net: dsa: mt7530: split-off common parts from mt7531_setup")
> 
> The commit 7f54cc9772ce ("net: dsa: mt7530: split-off common parts from
> mt7531_setup") is only present since v6.4 so backport to 5.15 and 6.1
> doesn't make sense

I should have actually checked and only now noticed that 7f54cc9772ce
("net: dsa: mt7530: split-off common parts from mt7531_setup") has been
picked to stable kernels down to Linux 5.15.

However, the bug only affects MMIO variants of the switch which are
supported since commit 110c18bfed414 ("net: dsa: mt7530: introduce
driver for MT7988 built-in switch"), and that is present only since
Linux 6.6.

Sorry about the confusion, I should have probably chosen that commit in
the Fixes: tag despite the original mistake was introduced in commit
7f54cc9772ce ("net: dsa: mt7530: split-off common parts from
mt7531_setup").
