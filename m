Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5642A18E744;
	Mon, 28 Oct 2024 06:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097508; cv=none; b=hA6aj8BLynhq2Vm9WgNxuE7RM4ObLAzca/pRVMl6psDTHkDZZRLoHPuNQFyB/WppXxoM4uSqwBFBtot42YRy7OzD126eRemiNBkGe0ooqjZOHHzUKN5vwHFXzhybc2+za73xDENz+Dgowi2ApbRbDyII30q49FuJQIaIvKbFw3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097508; c=relaxed/simple;
	bh=IdhbfHUeaSPL0ygznV58QODOdlrHs4gWglBUd9/Ni7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5zVpfhodszlJBs2pwxcgWWI9a9K9F758J6KzGX5OZf19qZ1qbiILfpZJxmLRsYI/9+ohSBNuanLliawhAEBE1tJCsBtPSv478Vhgbiija9lnBNuAl4VRkfkB5rCGn8/kRwyvjBhGmCXrbgH/vveuOTwA25s1+Hsdw4BPsa/+2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZN0+tE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZN0+tE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3773C4CECD;
	Mon, 28 Oct 2024 06:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097507;
	bh=IdhbfHUeaSPL0ygznV58QODOdlrHs4gWglBUd9/Ni7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZN0+tE6Vu81xfwsNGJANBzENprSOCkHxVdwIPjDPWhOGiZnhyR25rzEgofnvjWDL
	 +TFW6l80RTj1SNKE8mw4kBlaq7RTX5RxdYuF582dB6nzMuTFaR/iuzV25NQ1fYnbet
	 KmPJfafqy5l0TVxBM9cglPAswwBL1201vWr/gjvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Timo Grautstueck <timo.grautstueck@web.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/208] lib/Kconfig.debug: fix grammar in RUST_BUILD_ASSERT_ALLOW
Date: Mon, 28 Oct 2024 07:23:05 +0100
Message-ID: <20241028062306.787637477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index da5513cfc1258..f94c3e957b829 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2999,7 +2999,7 @@ config RUST_BUILD_ASSERT_ALLOW
 	bool "Allow unoptimized build-time assertions"
 	depends on RUST
 	help
-	  Controls how are `build_error!` and `build_assert!` handled during build.
+	  Controls how `build_error!` and `build_assert!` are handled during the build.
 
 	  If calls to them exist in the binary, it may indicate a violated invariant
 	  or that the optimizer failed to verify the invariant during compilation.
-- 
2.43.0



