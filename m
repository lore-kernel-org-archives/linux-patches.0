Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2217E0E4;
	Sat,  8 Mar 2025 16:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741452207; cv=none; b=hWJl1tdRLVddpd44hiDcggkMv0tx5XQ3A/XLaK1rwwqkXWUqPosXXqquOI3xn2nbYL2Xr/sUycQ8Pw8IsdzL1D8ltdIkuotVh0wNasHWSIRdxOHYnxOddILv6hgM/DUjPyiS8kCRVz1G4ZCfpgSfcgVCd9+h4JiGksHFmK2aYoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741452207; c=relaxed/simple;
	bh=giXjfla1IUB80vCiBZBA4tDUia2ogWeR+zO5AzfF78s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AkkvRcVt5ZhcR+jmunvzeSV8fCLU59rbOkxJOJ8u6erS1XYUBjCV9hCcg0BsXkbc5X/HtGWXHoCoo/4xxcF1CLGbeLP0f/Dxb2srDa4PBo3hnBN5thnUI8K8z7imxJBEFAzpuayU9exbs0fJOam2ggytIaSxB63EjwJejxuabMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=duKuCkEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="duKuCkEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53D2C4CEE0;
	Sat,  8 Mar 2025 16:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741452206;
	bh=giXjfla1IUB80vCiBZBA4tDUia2ogWeR+zO5AzfF78s=;
	h=From:To:Cc:Subject:Date:From;
	b=duKuCkEcowvy002FIXu9V+JBtDM12ZOgGND6SkEpSWuRsJTQliU5pDts3zMH9UGb0
	 MSiiV1EsH/CGSESA2AaXMKl2TVDwWmDSj9iQXGiN6yn0b7eOxBeCqfDMTXBDFxBX8F
	 Mhw35q92osqMnsUTb25oteaVApbhbAfP3qerWAERoBmXX7nVog3RwzTRxmLyzeCyug
	 /tNwNCStm8/qOlsA3FCvoYHzE/VyoVZf99dPsY0o4IkYEffFgQtWbYEsqMqyowHuYc
	 oNq3BlBYUj8+EiDlQWtw+F0lGsFuyY8z6hYRI3fIBwhnjv5jxqlWIpXU1yvKm7d0pv
	 1irCwFFw0rekQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] MAINTAINERS: rust: add tree field for RUST [ALLOC]
Date: Sat,  8 Mar 2025 17:42:58 +0100
Message-ID: <20250308164258.811040-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the Rust subsystem we are starting to add new subentries which will
have their own trees. Those trees will be part of linux-next and will
be sent as PRs to be merged into rust-next.

Thus do the same for the existing subentry we already have: RUST [ALLOC].

Cc: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8e0736dc2ee0..1ddc313abbdd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20732,6 +20732,7 @@ RUST [ALLOC]
 M:	Danilo Krummrich <dakr@kernel.org>
 L:	rust-for-linux@vger.kernel.org
 S:	Maintained
+T:	git https://github.com/Rust-for-Linux/linux.git alloc-next
 F:	rust/kernel/alloc.rs
 F:	rust/kernel/alloc/
 

base-commit: 7eb172143d5508b4da468ed59ee857c6e5e01da6
-- 
2.48.1

