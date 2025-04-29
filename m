Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6188F24501E
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 18:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745951668; cv=none; b=J1ltnK90TJmdU7A5Zc1uproYoTngsaESbPNc4N5xD4YyQ0WeS89DTrt476UXUNDdItSjj1eOd08TV8M5oN0OpZ8Ca/GPn24lbnz2rlmQsjZpXjqjKEo4n4oaV34zzP4xeldMAIFKVXop3572AI6EbsVaQ36ick/9KDpmeHgN5Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745951668; c=relaxed/simple;
	bh=+KDGRniRaEY0LPRUptxBLaGeF+c9xmSGYkvduRyjqF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxhaBFvRhJBmK+B9aI9jEaJPtlftedeiYdjgwYCy6ABbHpynwmonPn6CogqBro5p9aPY6Tqo/jRHNcqN2FdnXLUsrtVD6vU+SbOxhepllBioXHZdA26vofUpJjrWOj2AyKFuWyNpgzUq8e9bkDcfqNdI9Pr3zFLpQn40cnFykAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.98.2)
	(envelope-from <daniel@makrotopia.org>)
	id 1u9pgv-000000007C7-47tT;
	Tue, 29 Apr 2025 18:34:21 +0000
Date: Tue, 29 Apr 2025 19:34:18 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 294/373] net: dsa: mt7530: sync driver-specific
 behavior of MT7531 variants
Message-ID: <aBEbqsJhVNaLh82G@makrotopia.org>
References: <20250429161123.119104857@linuxfoundation.org>
 <20250429161135.207985097@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429161135.207985097@linuxfoundation.org>

Hi Greg,

On Tue, Apr 29, 2025 at 06:42:51PM +0200, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Daniel Golle <daniel@makrotopia.org>
> 
> [ Upstream commit 497041d763016c2e8314d2f6a329a9b77c3797ca ]
> 
> MT7531 standalone and MMIO variants found in MT7988 and EN7581 share
> most basic properties. Despite that, assisted_learning_on_cpu_port and
> mtu_enforcement_ingress were only applied for MT7531 but not for MT7988
> or EN7581, causing the expected issues on MMIO devices.
> 
> Apply both settings equally also for MT7988 and EN7581 by moving both
> assignments form mt7531_setup() to mt7531_setup_common().
> 
> This fixes unwanted flooding of packets due to unknown unicast
> during DA lookup, as well as issues with heterogenous MTU settings.
> 
> Fixes: 7f54cc9772ce ("net: dsa: mt7530: split-off common parts from mt7531_setup")

The commit 7f54cc9772ce ("net: dsa: mt7530: split-off common parts from
mt7531_setup") is only present since v6.4 so backport to 5.15 and 6.1
doesn't make sense
