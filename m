Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3ECA47;
	Mon, 28 Oct 2024 06:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097978; cv=none; b=YxgQjFPdZ7LmRqUzJFNArwcndePL1s+xOn2QQqB9q7PERkhjJCrfebopn+upXlv0eTDrQ0rHBFlx6HcU/EyMLICUThDU0F8VPrQNMXGeHjqbEPqcpt6qV2pz8FS569JGuJnfL7AJl1ulVKtT6xYn1Si/IiCoZXYTFpoZxz49wjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097978; c=relaxed/simple;
	bh=VEK4ydpOhmrDDZn5y+4ODz9NR9SSsICi8eb5t4G8RQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgKIw1hdTIPMX+hoJ2wL6qie/HY8gJ+1zEaIVetcIkgYJEtnoOfu6KckAlbySE5r4t/4kqXjYKDSaoRrhorOA0KN4wkbr+RcLMj3yt80oi1NrnlFwj6SLuenRLJB206+9FCVhI4VMlUt4QnIAvo9CvU68vkzZU6asq2hnBnyLt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7IkVr28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7IkVr28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18FDC4CEC3;
	Mon, 28 Oct 2024 06:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097978;
	bh=VEK4ydpOhmrDDZn5y+4ODz9NR9SSsICi8eb5t4G8RQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7IkVr289augV0jQlqgJOA80pW1TaPZcr75m4mGSTDkApmrfkjfDLZqwVjZDj3hHk
	 ABTubQ0/w5wjiNVSPtZec3yEcLU4S6Bdl1gKUiFh13I2MO1kXjTV9JhtzgIrKXIjEd
	 DgZRJ5QF3f5FkP9lzJANj3Wt5C0JN/HNsauCHf0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Timo Grautstueck <timo.grautstueck@web.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 009/261] lib/Kconfig.debug: fix grammar in RUST_BUILD_ASSERT_ALLOW
Date: Mon, 28 Oct 2024 07:22:31 +0100
Message-ID: <20241028062312.244266658@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timo Grautstueck <timo.grautstueck@web.de>

[ Upstream commit ab8851431bef5cc44f0f3f0da112e883fd4d0df5 ]

Just a grammar fix in lib/Kconfig.debug, under the config option
RUST_BUILD_ASSERT_ALLOW.

Reported-by: Miguel Ojeda <ojeda@kernel.org>
Closes: https://github.com/Rust-for-Linux/linux/issues/1006
Fixes: ecaa6ddff2fd ("rust: add `build_error` crate")
Signed-off-by: Timo Grautstueck <timo.grautstueck@web.de>
Link: https://lore.kernel.org/r/20241006140244.5509-1-timo.grautstueck@web.de
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a30c03a661726..8079f5c2dfe4f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3023,7 +3023,7 @@ config RUST_BUILD_ASSERT_ALLOW
 	bool "Allow unoptimized build-time assertions"
 	depends on RUST
 	help
-	  Controls how are `build_error!` and `build_assert!` handled during build.
+	  Controls how `build_error!` and `build_assert!` are handled during the build.
 
 	  If calls to them exist in the binary, it may indicate a violated invariant
 	  or that the optimizer failed to verify the invariant during compilation.
-- 
2.43.0



