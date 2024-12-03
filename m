Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909D3646;
	Tue,  3 Dec 2024 15:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239091; cv=none; b=fJtp21/aUjRKGIll8W1M50FNyytg/1byQTcLsAy+sAoApd4Y+SUNMzub9Faoo9YI4vkgKCXR6AJZIsGOWr4uzooAhY/r6JslzWgh2XJVEYWXZsUhxAzuUf3srjXOn6ewt+LYWPawGUdOdC0Q+DbfCOxSizoxousLjKrYWUX7vIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239091; c=relaxed/simple;
	bh=ofTsQ1sqJ5r8e5PYHzQJzL2q0DJy4j8oteTwNAq4sgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AL7LyzY/Q8xa9Km3g4CBRdqx6WS4T3aQabMv6Sjq/gI+LrjcSZTQAT7puuD8h4NU8YU2kZGMVI6rwlJyka1Fh5N6Nqt2AANuAGoTDMaeLFz7M4mywCWiS+pmXC2S0B9HwImdAtjM2yUtnad6JXo96+WC4zX52gmRN7+ssNXorkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFR88nsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFR88nsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1952CC4CECF;
	Tue,  3 Dec 2024 15:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239091;
	bh=ofTsQ1sqJ5r8e5PYHzQJzL2q0DJy4j8oteTwNAq4sgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFR88nsr50ivEKF0jdXd622Fw5U/nxQZ3x6BFgCdySwE8kRvdtKnMBCNCKegAjG2k
	 wvUfmWVcR04NtsDNJHNygXfhYnbZ37GMaiS/INAEYLwvQe08kCr9NUr9kUUdoeyjOx
	 NXmJFBtxo0MR9c70tlniOEsvKkQHoh3eY6g0TVJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yutaro Ohno <yutaro.ono.418@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 499/817] rust: kernel: fix THIS_MODULE header path in ThisModule doc comment
Date: Tue,  3 Dec 2024 15:41:11 +0100
Message-ID: <20241203144015.351801334@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Yutaro Ohno <yutaro.ono.418@gmail.com>

[ Upstream commit 8b55dc8610acf816a66373be53ca6e3bbe2d313a ]

The doc comment for `ThisModule` incorrectly states the C header file
for `THIS_MODULE` as `include/linux/export.h`, while the correct path is
`include/linux/init.h`. This is because `THIS_MODULE` was moved in
commit 5b20755b7780 ("init: move THIS_MODULE from <linux/export.h> to
<linux/init.h>").

Update the doc comment for `ThisModule` to reflect the correct header
file path for `THIS_MODULE`.

Fixes: 5b20755b7780 ("init: move THIS_MODULE from <linux/export.h> to <linux/init.h>")
Signed-off-by: Yutaro Ohno <yutaro.ono.418@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/ZxXDZwxWgoEiIYkj@ohnotp
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/lib.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 274bdc1b0a824..4b25c9a474c24 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -80,7 +80,7 @@ pub trait Module: Sized + Sync + Send {
 
 /// Equivalent to `THIS_MODULE` in the C API.
 ///
-/// C header: [`include/linux/export.h`](srctree/include/linux/export.h)
+/// C header: [`include/linux/init.h`](srctree/include/linux/init.h)
 pub struct ThisModule(*mut bindings::module);
 
 // SAFETY: `THIS_MODULE` may be used from all threads within a module.
-- 
2.43.0



