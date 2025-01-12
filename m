Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABA61B6CE1;
	Sun, 12 Jan 2025 15:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736695801; cv=none; b=uvSRmE8qXNWbc/Ql7nlVZ3yZzu9OT6Y4G8glVZNp7xvW0OK77HoNgN0Jl2rswQB0TLIqxHX5hpVmSUJTPgwfUy+MF/RHAOCz3MCzLeTicooD9HXEi+jlFs12svtfKqOs8jgnZ6/YZxB2VGBkcFjOF/3tvTDetb6ZUTF0LfPeU9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736695801; c=relaxed/simple;
	bh=5n4rv3ZWhJJOW+kQB8Ca/KAiE8vF/g6y78Qv0oArNFw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kNl1etU8nVFHrzuDJyORH1uX+dn78xHDOE+mEbmHUB74FPTwwZLBvWQaRapaL4Id4Tm6zsw0rsPRKBczZ0+cgeXeuGO2uWcHM7diAY5flCjKmWXZ6SWajdW3DGk7HQhgqjEdQ3ba3O+dlX/Fu5l74FVuuemZogNlqRP6hOnSqG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXzyKYBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXzyKYBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38522C4CEDF;
	Sun, 12 Jan 2025 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736695800;
	bh=5n4rv3ZWhJJOW+kQB8Ca/KAiE8vF/g6y78Qv0oArNFw=;
	h=From:To:Cc:Subject:Date:From;
	b=bXzyKYBjtf5KMiVSDFWZaGyKuhx5w85xpt+MMUlxuD2vlYSyGXdkI+j4vrd6lSkIX
	 G7dQHs3JuE/9rt3iwdpeI5r3en9jxvz59mTtIMb5uCPSKE8sE8BncL3gMtFJxzsdVf
	 Za/nHilb9HVHKLxA6+IGas6E+v6j1UwE8nu5YSmtISh18QqE5xFY8UaXsbX7XGCTrO
	 372Wvyrxh/8KmssaSxNNY1PUHgPJuekS7pwC4ZVaWdTgepLvOrmObQBEz6GTS+3526
	 oDIDArfs91zg9xLuoZcN0ib9ZFpThIVN7RHfMiDpmysx3pCXQdOGKFCOAfKWi/L+xp
	 PY47fKJsnO+nw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	tech-board@groups.linuxfoundation.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/3] Clarifications around Acked-by and "# Suffix" proposal
Date: Sun, 12 Jan 2025 16:29:43 +0100
Message-ID: <20250112152946.761150-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A patch series that aims to clarify what the purpose of the Acked-by tag is,
in order to help newcomers understand the kernel process better, as well as
to give extra flexibility on the usage of the Acked-by tag.

It formalizes one of the proposals from [1]: "# Suffix" for Acked-by.

I hope this helps!

Link: https://lore.kernel.org/rust-for-linux/CANiq72m4fea15Z0fFZauz8N2madkBJ0G7Dc094OwoajnXmROOA@mail.gmail.com/ [1]

Miguel Ojeda (3):
  docs: submitting-patches: clarify Acked-by and introduce "# Suffix"
  docs: submitting-patches: clarify difference between Acked-by and
    Reviewed-by
  docs: submitting-patches: clarify that signers may use their
    discretion on tags

 Documentation/process/submitting-patches.rst | 22 ++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)


base-commit: 9d89551994a430b50c4fffcb1e617a057fa76e20
--
2.48.0
