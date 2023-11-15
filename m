Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D04B18657
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 21:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="d0DLzk9C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=UL8lENppiEaSbeKPLUW4prwK1t4QPwKLtXNCJov895c=;
	t=1700084134; x=1701293734; b=d0DLzk9CY48FU0gYlACbJy7vsBl1bp6aIAm8R0ZLCf94QnL
	KjKNxdfH4QMcRQTVeD2+tKFb7r+BYuMA9GRuqhkSPFRLUU8ugjT+96MM7TjiP/D4JWOvFW9Dat5PY
	1sI42km7Z+BGNLu91zLEnC1BRYLGnZZ9TBnTxviaw6HU65x/VJUPkKw4E3adBqfM5XT3DkYJE/gHo
	YRqdsdVbwdRVyP0Zxr0orzxBm/Vloz4wB6+opxKlyChRtg+D6rANvffWCPqkgt/v/YkdnGzADonc9
	RIeInc9CtYtdO+NGSSUfTHHCYGDyrzllOYOSV07VPRYK/PsYp6wwJvAfm2r8LeWw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1r3NXR-00000009QHB-3AcP;
	Wed, 15 Nov 2023 22:35:09 +0100
Message-ID: <173d2adc744a2878544c14c3960765587bd96521.camel@sipsolutions.net>
Subject: Re: [PATCH 5.10 010/191] wifi: iwlwifi: Use FW rate for non-data
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Korenblit, Miriam
 Rachel" <miriam.rachel.korenblit@intel.com>, "Greenman, Gregory"
 <gregory.greenman@intel.com>, Sasha Levin <sashal@kernel.org>
Date: Wed, 15 Nov 2023 22:35:08 +0100
In-Reply-To: <20231115204645.129133114@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
	 <20231115204645.129133114@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2023-11-15 at 20:44 +0000, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20

I wouldn't backport this patch anywhere.

First of all, it's only _required_ for real WiFi7 operation, which isn't
supported in any of these old kernels. Secondly, it introduced a
regression wrt. the rates used by the firmware, which, while not that
important, caused some folks to complain.

johannes
