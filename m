Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318780;
	b=26s02rSVPT0yErfZExg9KBG0yk0zLT7b9fxILnHUOSmBzulICf1l5Z4+tnuIOci/x0fF
	 FnrhGwrDNHbo2DOib/qp40KR7Y0NTmhueLTryuIA3IukJi9vjET4hFvJHLDPwQqUkj0o+
	 +YXfGAFKfiTSkGfLvN22HIbuarqPcGxo6eeiBKvkxH7v9UAFXT8N92/s+uBiJv2FUovQb
	 OjALX4XSZIOpeOYPpWdHzkJYeCpQvCLpM1QIklMok4ww1P6SNGIaN7xzpewqX6Lew653t
	 N70N36ZAI1w+Fp9KXpazmS1E9gdNd5ALChDL5xg4YRRel8NF+c63hF84PXmLQXAsPrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=3D4APvmrFklnDSUBFGpwDBPGcK9I8i7K8bRoGUhtPUc=;
	b=doXuD+mDpnwJiMtRc8Dc9YUvA1Bn79rIwhroWu1vyjdXRfmjY16IVuXKrpsJD5b3o2yD
	 NcGqA9keybNNHCMQWYbDViMfDnZ7z/bku2N4vdcu1AQ7GJOdeBJsifM8697kFOELdh22X
	 5TSAuW9ciDljjekDwYKshiQupBpawbHSDWnWxOnh+7Wcb6VOq3PJ5AqS80QuvZ7zeZUyz
	 MFqqa37QsC/L0zNGTANaZM6SG40pRop+uegE5jt34HzFisOguHudZIQejX1TbdbnflJAt
	 JE33jRgz4boT83GcL2X4FhVL8+d3wUPTqEjYYs7XOsxK9Kk0aScE8CVTG7Bk4Y7Ttag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xi1sEM+Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04232606A32C;
	Sun, 22 Nov 2026 03:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xi1sEM+Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186451F000EC;
	Sun, 22 Nov 2026 03:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318779;
	bh=3D4APvmrFklnDSUBFGpwDBPGcK9I8i7K8bRoGUhtPUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xi1sEM+Q3CswhML/iW21EZumDJPTElF3svxmEm0x/q5HYBCnKsNGSFL2Qc+Ag8QBz
	 qOEMww69cYASX6WEDrhIsex3Blv24Qi3kTk5BPvfmhXvAooCqkzFq678yMSkxF2G+S
	 gZ+Uuy0PEDqXb14DJbeJsGIPWl+AEf7eri/xfTT9ns9/nAPq0Y0IfspSQAK1CdL2Au
	 feQYt8AmNuKCPpBb48A8ICVuXwtbEbfTCO8xLIb6MMBB6dvb/CEvY6Mipg9iYpdUFX
	 johGRNyw5saZFUalHCje55O5eZGJUk2fIqHPN4WV6f8L0yX/13Plx0hQzuc671KyyD
	 3wjX5s/PIsRrg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	renpanpan <renpanpan@kylinos.cn>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 1289/2214] drm/amdgpu: Only enable HDMI audio if display supports it
Date: Sat, 21 Nov 2026 22:39:05 -0500
Message-ID: <2026-11-21-2-daily-reply-0022@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1df2aa0e-0cfc-4d21-85a3-d74e4ea83d3d@oracle.com>
References: <1df2aa0e-0cfc-4d21-85a3-d74e4ea83d3d@oracle.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> DCE v8 and v10 have the same change, maybe we should provide equivalent
> audio detection before using this gate; upstream uses 0374ffa507d8
> ("drm/edid: parse display info has_audio
> similar to is_hdmi").

I'll keep this one on 5.15 and 5.10. drm_detect_monitor_audio() reads
the first CEA extension like every other EDID path on those trees (ELD,
SADs, drm_detect_hdmi_monitor()), and display_info.has_audio doesn't
exist there. 0374ffa507d8 depends on the v6.0 drm_edid_iter rework.

-- 
Thanks,
Sasha
