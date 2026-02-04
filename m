Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3962BE621;
	Wed,  4 Feb 2026 15:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218466; cv=none; b=UwD3nlF4WRLCglReGlzSVu4MJZ0n3zvYERt3HEORaK5+Hw6Yxmp+7wf1nVeqBbsgXRJSXUpq9ntU0Kzp75t6YZgGJGcj3TB4DFqTq6/NxO+gJqsydgmsc32Ap4IXm25x/xnX98kLvD2zbg1E+6Bnku9vWIeH+qKwis/pEQlacao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218466; c=relaxed/simple;
	bh=rExAKUxolcXqOHLhubSJO+U7LFYqFwFbGefiNoKMFw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdQW5/s+8GUN5HwoLtyompNrDX/+LpFUuHvQJ7aZ1fJQ30Wsb60nn52w19G08+TMsVzIz+F1K9hSSIMTAroRqK2TxNaJifAotNbrybx5YjHzoL3omqPjt8KqnDaa7dl1WjE/80EW5/tnRuazjjCUx9w+W6kKcWkp9nNPdd8XYiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7IKEkPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7IKEkPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B1DC4CEF7;
	Wed,  4 Feb 2026 15:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218465;
	bh=rExAKUxolcXqOHLhubSJO+U7LFYqFwFbGefiNoKMFw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7IKEkPwudslkG9suvrf2G+aBRNTocj7RuWon2e6vz0YulZe+Q9Eh5xJorV/yPNqz
	 iHxYX3HOuPEr87mUkDB+0TeNdrnNdaNXdEng/ECn6GxDO/rJTAWw3KehM+Y+emyyeT
	 W5cmczXHGVQD20WuAkB3tZklYP0YrzE4jo15H6Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Duberstein <tamird@kernel.org>,
	Jesung Yang <y.j3ms.n@gmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 37/72] scripts: generate_rust_analyzer: Add compiler_builtins -> core dep
Date: Wed,  4 Feb 2026 15:40:40 +0100
Message-ID: <20260204143846.970121076@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamir Duberstein <tamird@kernel.org>

commit 5157c328edb35bac05ce77da473c3209d20e0bbb upstream.

Add a dependency edge from `compiler_builtins` to `core` to
`scripts/generate_rust_analyzer.py` to match `rust/Makefile`. This has
been incorrect since commit 8c4555ccc55c ("scripts: add
`generate_rust_analyzer.py`")

Signed-off-by: Tamir Duberstein <tamird@kernel.org>
Reviewed-by: Jesung Yang <y.j3ms.n@gmail.com>
Acked-by: Benno Lossin <lossin@kernel.org>
Fixes: 8c4555ccc55c ("scripts: add `generate_rust_analyzer.py`")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250723-rust-analyzer-pin-init-v1-1-3c6956173c78@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_rust_analyzer.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -73,7 +73,7 @@ def generate_crates(srctree, objtree, sy
     append_crate(
         "compiler_builtins",
         srctree / "rust" / "compiler_builtins.rs",
-        [],
+        ["core"],
     )
 
     append_crate(


