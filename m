Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB6622A1E6;
	Sat,  5 Jul 2025 11:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751715917; cv=none; b=b2TC/+A2+rlNVPx+a8nXlY9UWU9H/GTyFN3c2El8b9dg8OX3qLXYLYFpm1ebUJ5YXVDZYS0++JtqRk1vb1fvVHlNNxHkCvlciebPZYzctufaBlHMLsqM4NhU3H+U1r4rgR/r9mEsN4rs3iuS6yNkcUmCmRgWmGLNiYuKcggMDLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751715917; c=relaxed/simple;
	bh=+BV6OpLlrUde9aij8xsLL8JTdPuHj6ctG5JVJeDJeBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKLbal9JSmluLQn1/g55wbc4abOfBv6P1Xi4zLkb61t9afTPZth2YaAA4eeutqiAt4DIziFsCtyQKlpdadW/9Jd43P5mO/m0Nu01UKcu0IE5USIYpYtht+NglRfu8O0epqz05s5p33TV/F2vu8E/humHRCekFHUL8V/xBiQj3gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXh+tJRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXh+tJRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2961C4CEE7;
	Sat,  5 Jul 2025 11:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751715917;
	bh=+BV6OpLlrUde9aij8xsLL8JTdPuHj6ctG5JVJeDJeBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXh+tJRTpEMfX0AyOu9hizFf7vGzkY5FT1cLf5YjkmBim6FtiXMZ3KUX1R9T5gIP7
	 3Ub/JfcCfkDaC0UKCsYjksZMS//o07FV9PAHdhTn7cjFTPkZXPrTVyV39SWfvx7W67
	 FKSNl/J2yuyiePuC2t9viRgOEkFTQn/r3RKc73IqU4X2nr70KMWQPBdWmz4+3ScStu
	 VTTxfznGdwdQi0HPR1v5VWZZOVR6TqC6GO/oY0+ITxNHoSfMvHmjFLo3sq/iYWMgQB
	 6yHAVbxRpjx3fuMZBYUv+0Ocm049/QkBbEuRmu3r6dRJuJASel6BM0jRjqaeoujZwX
	 xeMARZHvz1XzQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: chenhuacai@loongson.cn,
	maobibo@loongson.cn,
	patches@lists.linux.dev,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.12 206/218] LoongArch: Set hugetlb mmap base address aligned with pmd size
Date: Sat,  5 Jul 2025 13:45:00 +0200
Message-ID: <20250705114500.360382-1-ojeda@kernel.org>
In-Reply-To: <20250703144004.457285463@linuxfoundation.org>
References: <20250703144004.457285463@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 03 Jul 2025 16:42:34 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> Cc: stable@vger.kernel.org  # 6.13+

This line makes sense -- it sounds like it was indeed not meant for v6.12:

    https://lore.kernel.org/stable/20250704231046.332586-1-ojeda@kernel.org/

Cheers,
Miguel
