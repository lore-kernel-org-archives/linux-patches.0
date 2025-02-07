Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F408C238D35;
	Fri,  7 Feb 2025 15:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738941075; cv=none; b=cFFyTyif0DG3fl11bvylJLLxE/rEhSJc1XDf/FQeiUydcI0lB9pw4apK8jdJ0542SNlzyivLunyOGdAyoRzIsqv1yIBOt59SkA6IziI9qF9pPsgp/m2cjrtDH9CL3M+yZ/dMVvJX2L5+5q4DnD/JomDBFmGkajUHwsBu/knATbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738941075; c=relaxed/simple;
	bh=vVOgouhQKqrEbhq54OpKx7ljlY1Pkt2dlXim/m2zv0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OVUDM33TloSDo1/3etW2J5wouaMPJ57sOp2utmEehqs9dwc0DoWL6q+NkudqSFKwy05mvZEhDsiohucxCJ9XUt96kII4bT7X47zOWwEe2vpwVP9tzQHqUMRzb/izZWBSedsHfSxP1HnBHuPjdVWWSXf8Rwd5C4ifgbnbHSiHCtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oxlY8CiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oxlY8CiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688E9C4CED1;
	Fri,  7 Feb 2025 15:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738941074;
	bh=vVOgouhQKqrEbhq54OpKx7ljlY1Pkt2dlXim/m2zv0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oxlY8CiRqUG0H2XUugCd8/rRVf0Z3f57Z2ZptDHdUCERDYyaMFDZPK5lapQInq5Hd
	 kozQBlEMRDk4En7Zoio+2ruIubJrDUQVUAyHSETo2HrO4+vrZ2NLeCTcjBaqOZ+IPc
	 lhDKLl+2MW9rLslAWuPzPPI/l/wWUE4GDsN0ibvyo4C8NXy3pO7bXqDbpm9zceeTUf
	 U5Cv++hR3hz6ZNFVcwDO1ZxWeBpaygua2pVPHA9i5j53LLRhpKSeLyGhq6s63WIm+q
	 YvANJSA86aJq2rSi716pliRGuC28CLrkS1XY+rB9z+iwS5URtqv5QJN7/Bv9YjMfzw
	 MRIodBqIYKx8A==
Received: from johan by xi.lan with local (Exim 4.97.1)
	(envelope-from <johan@kernel.org>)
	id 1tgQ0o-000000002Vx-3o8a;
	Fri, 07 Feb 2025 16:11:23 +0100
Date: Fri, 7 Feb 2025 16:11:22 +0100
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 541/623] PM: sleep: core: Synchronize runtime PM
 status of parents and children
Message-ID: <Z6YimpSNja_Fkgju@hovoldconsulting.com>
References: <20250205134456.221272033@linuxfoundation.org>
 <20250205134516.919594202@linuxfoundation.org>
 <Z6YQpnfhXRh5oHRi@hovoldconsulting.com>
 <2025020710-antiquely-gone-caa7@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025020710-antiquely-gone-caa7@gregkh>

On Fri, Feb 07, 2025 at 04:03:31PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 07, 2025 at 02:54:46PM +0100, Johan Hovold wrote:

> > This patch appears to be causing trouble and should not be backported,
> > at least not until this has been resolved:
> > 
> > 	https://lore.kernel.org/all/1c2433d4-7e0f-4395-b841-b8eac7c25651@nvidia.com/
> > 
> > Please drop from all stable queues.
> 
> Already done, and -rc2 releases were sent out yesterday with it removed.

Ah, good. I found Jon's stable test report now.

Johan
