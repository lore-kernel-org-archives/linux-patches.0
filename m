Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EBF12D753;
	Tue, 30 Apr 2024 11:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476538; cv=none; b=XdnFuxGdazHbBHkPhbBNHoLlqwyvTGvZeI1p7928/6pJjJB11Plm5aIEfz//RXLnp/R996qmqOzG+jM1yB0ZOu2W9FVrR3F9E9T+PQsBCVbSfr8Ra5JzR1mTHEVfZL+AC60EhuswcSOGUj5B/tx/mOX5/GMLS+67cf4Zuq+8t7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476538; c=relaxed/simple;
	bh=uEF5edBPjjsWOM5cUwMRuPNg6m1kW8Yu6BMXcEPInh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbo0Bka1auCmn6t5N5o4XxoJ2EK59z14zcpdtdoz4nZ+SRTElNlwNEqJ3Zr0egFjKr9IWj0fsQ6V4q4QrLa2gGCLgTRb1GhOqx/uXb/SISR0WiZ150eYPBP64ChfIUH7D6VOGCf+zv41ahtM7U2ttsrAMu14pJNjK8+wNf5YxfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlWQm0t8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlWQm0t8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C665C4AF19;
	Tue, 30 Apr 2024 11:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476538;
	bh=uEF5edBPjjsWOM5cUwMRuPNg6m1kW8Yu6BMXcEPInh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlWQm0t8rsnWzTDoj/RNy2gKeC+ThrorBCRFTkHjpfRUuPaNr8ZpyiFxAvgWArB+h
	 P09E6M/43Sj2L8Whnp/w7tYGcqOEX896j+PqvlSHakBPQGGmjZIRVclIaVuy1l0Wco
	 /K1l1v21bS3Un66rRY45Qqx/hsC96RK6j5bmNDTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.1 064/110] rust: dont select CONSTRUCTORS
Date: Tue, 30 Apr 2024 12:40:33 +0200
Message-ID: <20240430103049.457708886@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit 7d49f53af4b988b188d3932deac2c9c80fd7d9ce upstream.

This was originally part of commit 4b9a68f2e59a0 ("rust: add support for
static synchronisation primitives") from the old Rust branch, which used
module constructors to initialize globals containing various
synchronisation primitives with pin-init. That commit has never been
upstreamed, but the `select CONSTRUCTORS` statement ended up being
included in the patch that initially added Rust support to the Linux
Kernel.

We are not using module constructors, so let's remove the select.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Cc: stable@vger.kernel.org
Fixes: 2f7ab1267dc9 ("Kbuild: add Rust support")
Link: https://lore.kernel.org/r/20240308-constructors-v1-1-4c811342391c@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1924,7 +1924,6 @@ config RUST
 	depends on !GCC_PLUGINS
 	depends on !RANDSTRUCT
 	depends on !DEBUG_INFO_BTF || PAHOLE_HAS_LANG_EXCLUDE
-	select CONSTRUCTORS
 	help
 	  Enables Rust support in the kernel.
 


