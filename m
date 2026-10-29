Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793242407;
	b=ufZuS+tVnIC0Z45Am05mxgUo/51uahK2uTEI4l/ItTEujSeqhdaJFiD9QXZGDGX3oj1a
	 +OlXZiFHzdY/0ZbLnFx/CbUWW+XSlj+PKxYA7J+50BQbPk1nFAskLJIB9WZ21YDwgcyWV
	 uGr4W1/f4D+ZQpnha7SCMCgu94MykWsvyDQJJkWMcdyc4CH1BZHmn2R2eSvVZ3JHIG3ma
	 1On3pJM170wgk/6MPEHLzhY6IUN9ggkLTGYnvZgiK6wU5AdivrQym8LvOz4bBg9ZTnSaf
	 VBjeaKwWC2euJd7Hs3ZwBBebA3DtJ3anbb4+JyLXdZFTAdDlywnsw+YbBDt2eVFFZbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793242407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zSeiMEsNySs8kLpj6IkrNSIGVnTsFwiiiBuuMKjbrOI=;
	b=G3Xuo8NA8hc8CHoYpr+zZ066PEU1RlUD4Jrr34RujztHgdVHfcGNjTICDb1ibyPq5uH3
	 vmuL0+F5PncglI9wvruuFiHhUAxmdEsBKuGQXAJgNBe10R0+SHlj052UiPV0KONo0zJjc
	 mPy0/ST+hDMZxH7mnAdcLScRaSb6UnkTFmn7CsKHyeajoDFV756JCiz6hKUGPGidbu/0W
	 EQ70wS385CaPHAFLNtdRic27+FYp3m0SnAqXHKOxkZc24MAT8XT88AOXD7wOqrY1Bt/n/
	 OgY+nRWSD1TyAT/iT3NXsb4ptozdK7lNK5KqbgOYa8KtjnSkFKTdZeM0cD31ZEzHO2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ve3yuMJo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51D8606A322;
	Thu, 29 Oct 2026 02:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ve3yuMJo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7BA1F01829;
	Thu, 29 Oct 2026 02:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793242406;
	bh=zSeiMEsNySs8kLpj6IkrNSIGVnTsFwiiiBuuMKjbrOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ve3yuMJowmhCJ9aHCDpbvFWX/HSUTK0tKzGXG6t4RYjBS2FnG1+8BaYaikSLfMNI/
	 yvxGap2SIwS5bvjXUCRFRKJvemSCuU+hWVjCAPgFDwW7mtotFSi/AgIusvCGdE789V
	 D0cjUnPzJe85h4QVqDr1DS5tVSYJKO7RWiaVZWpROADjtMOI8WLZwByfuNHWB7AlJd
	 1XNyI7FijqhoBgBwp7q8q5371Sr88obuaf0wnhgrvcok8mlkqdUETkEvcFZGHE6wea
	 cRCNc8izdbabITwENIa2qY+aKEvxQ0R676LE6xzX04jEmrTSdcAgw65MgODjiIqt23
	 Zx7Ina4+V0smg==
From: Sasha Levin <sashal@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Guenter Roeck <linux@roeck-us.net>,
	Edvard Conrad <edvard@tuta.io>
Subject: Re: [PATCH 6.12 122/247] fs: get rid of __FMODE_NONOTIFY kludge
Date: Wed, 28 Oct 2026 22:53:19 -0400
Message-ID: <09fded57a6074dd89485.sashal-rc-0003@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAOQ4uxjuTuVpx9GV86vt8JwKk9qOPayV7dx_86EofozKkK_kWQ@mail.gmail.com>
References: <20261028165947.349197979@linuxfoundation.org> <20261028165950.290722602@linuxfoundation.org> <CAOQ4uxjuTuVpx9GV86vt8JwKk9qOPayV7dx_86EofozKkK_kWQ@mail.gmail.com>
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

On Wed, Oct 28, 2026 at 7:56 PM Amir Goldstein wrote:
> Objection.
>
> This causes a (potential) deadlock regression:
>
> https://lore.kernel.org/linux-unionfs/P4sl5iz--F-9@tuta.io/

Dropped from the 6.12 queue, together with its follow-up "fanotify: Fix
crash in fanotify_init(2)", which does not apply without it.

For context, it had been queued only to fix the sparc 6.12.y build
(fcntl_init() BUILD_BUG_ON) that came from the 6.12 backport of
"fsnotify: opt-in for permission events at file open time". We will
revisit it together with Edvard's fix once that is in mainline.

> Not sure if this already hit other LTS kernels.

6.18.y, 7.2.y and 7.3.y already carry it via mainline (v6.14), so they
will need the upstream fix. 6.6.y and older do not have it.

-- 
Thanks,
Sasha
