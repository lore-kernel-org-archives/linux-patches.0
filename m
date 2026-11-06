Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793948833;
	b=1t+DGAh3dfrDyBBHJV0ylCbE8VrZt4vraEI7NWFy7KfSm2X0f4L8pHfqZkZK5hthcaI2
	 oj976/oBPr3YGfN98pTrvJaVROM9UKM/JDevUNhydLxPOeD3X1pUajw0Oic4RiX5ex/0J
	 8Ce9Ln5AHB3L0ZGeWAjEprj/tyZNf+8upsUociLAtncTOhdc0X++OzqAWuWakM8WPLWKv
	 nWgyQ6AOPfDIVlAcH+9lZuS4Vs5luIXZg0sK9vPemoYwwcmwg0MSeFCmpcOWdFxCZurA+
	 A7oVx7ht7NdOWxH/q0/2HfG4uwHlwaKZiyvOAnmeQvX5P72EhN8y7QrSsm46Tua4kvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793948833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yT0Ls4Uz/spnUSXjIJe5AEFI8sITXW0uYiih29/EVpw=;
	b=hKRwxcMANXbemELaZrF9O6iUAsl2Tfxng+xjBLhOOChvLGBMye5essi5lndd2K6mnDl9
	 tsI8j9Ao9z7ss++nq/32NDeEcocbftrMIXzTosgEWtan+XGcN89tm68PAjmS5Gt+yG4aa
	 6oxEpKonK3MToZZcGYGrQxWKUUVW7PZE8L/XKezn2FYo2Lr5XJD//DiS9qml1AlzvCq0f
	 h+eLIxbzgNKhYLm4ZTLElNaZvd2I5HBrn1/ZZEcoRnXuDAN8iQQ9Umyfyop6GKDtaPoqk
	 It5qRaCJovmoNxWbLDuKazSb1Q+WaXI+XZDtyUTIy7921U1v1m3MRE8l6N6e+jdldEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Nfu6V/3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB740606A329;
	Fri,  6 Nov 2026 07:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nfu6V/3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE311F008A1;
	Fri,  6 Nov 2026 07:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793948832;
	bh=yT0Ls4Uz/spnUSXjIJe5AEFI8sITXW0uYiih29/EVpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nfu6V/3/Lrj/gU0s4PvfELHxmFhwuGwVXRtxuVgM8ylMfvqXp3B1M5UI554eVwQ8/
	 iLCclbp9xwkdtBM/DC0Ubis/5yWOTU7auDN9jBkIj+VaDV/w62ypMBYfyBGgcWEwGj
	 rjx6i7DrNHnllItLRTqxj37Z6XbSdYqDr8ZoBL/0X02Vpar00t8s/15a6UKTd2+QkN
	 gcG2uHgSUoo9lM3V2NyezbkGd1i3arosrivVwjfLOgPC+HSRHqU97CbgbPmDT8le18
	 UsUk3OhoqAUaYOvH2k/ZRUuRE2/xyDH57kFP15bDozCGYFkgBlYZAltOdL/4J8rjMw
	 sxGT3wpezW/IQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: burak.emir@gmail.com,
	ecourtney@nvidia.com,
	ojeda@kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	ynorov@nvidia.com,
	Alice Ryhl <aliceryhl@google.com>,
	Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH 6.18 0699/1005] rust: bitmap: restrict bitmap length to at most i32::MAX
Date: Fri,  6 Nov 2026 08:07:01 +0100
Message-ID: <20261106070701.89282-1-ojeda@kernel.org>
In-Reply-To: <20261104211103.174756107@linuxfoundation.org>
References: <20261104211103.174756107@linuxfoundation.org>
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

On Wed, 04 Nov 2026 16:07:12 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> +/// This also matches [`BitmapVec::MAX_LEN`].

This is a broken intra-doc link -- it can be fixed with a trivial
one-liner I just sent here:

  https://lore.kernel.org/stable/20261106063745.87864-1-ojeda@kernel.org/

But another option (cleaner but a bigger change) is to cherry-pick:

  f5535d78e126 ("rust: bitmap: add MAX_LEN and MAX_INLINE_LEN constants")

Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Burak Emir <burak.emir@gmail.com>
Cc: Yury Norov <yury.norov@gmail.com>

Cheers,
Miguel
