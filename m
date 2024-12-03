Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0CF1DE8A5;
	Tue,  3 Dec 2024 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241680; cv=none; b=nDnxihiM3aC6zzl4+M9nC1qHAf2TJxfXpGEx4IcWZs2F2QXHjVL06VA0NrRZVIqJgp77S/Oi9vs+3rRHmjQuK6OpQbk6hVNdzBX8cxqnE2jUpmEprSPXPuuw/GDrioW69O2mTzfkIMbFJCWRa6TfXJkdixyOEQacR/e14gAT6Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241680; c=relaxed/simple;
	bh=SC6qY179a8toCe4YFsv6z1vKE0MRX6+xxJZdFBnJ3mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/xWdPomAgeHJoookMdtIL6WpnxZBYbaV8lmdrJ5KLuMH2A3q+ZlddD0EONJkGQHHQIrXwmHTHoOcz2MLyBAddhmxTNsR3qAS/WbepFnFfAHYr7r8yWaI4qnQxwAwrn3GcZm1FvkaFlPoiktMX3y0rcsSUvrjhzunG+y/sLzxw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGMhmm8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGMhmm8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE53C4CECF;
	Tue,  3 Dec 2024 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241680;
	bh=SC6qY179a8toCe4YFsv6z1vKE0MRX6+xxJZdFBnJ3mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGMhmm8KFtnEJCPw8GAIGYLmvuo3h7tGsjvbd4Lp+1swuTtule083WbXJXg7N3rye
	 gc/qQFREOthmvu4xIYR4Q0irlQNTEpiwSVN7SEYFO+ExnOcWnxXUVGB0z8xXLpbhSN
	 LcklYDWwDLFnP+eTinAnxCnNSI6YEZhdnBn4RXSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yutaro Ohno <yutaro.ono.418@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 488/826] rust: kernel: fix THIS_MODULE header path in ThisModule doc comment
Date: Tue,  3 Dec 2024 15:43:35 +0100
Message-ID: <20241203144802.794718972@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b5f4b3ce6b482..032c9089e6862 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -83,7 +83,7 @@ pub trait Module: Sized + Sync + Send {
 
 /// Equivalent to `THIS_MODULE` in the C API.
 ///
-/// C header: [`include/linux/export.h`](srctree/include/linux/export.h)
+/// C header: [`include/linux/init.h`](srctree/include/linux/init.h)
 pub struct ThisModule(*mut bindings::module);
 
 // SAFETY: `THIS_MODULE` may be used from all threads within a module.
-- 
2.43.0



