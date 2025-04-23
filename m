Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E83219DF4C;
	Wed, 23 Apr 2025 14:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420205; cv=none; b=VFyw4AxKEedMXGmb4s6wmnx0gBa22hG27UXiaLEMHtJ19i7kJKRmmK5R3lMGo3mbeqVtlys0GLmQZa8a3ChaN5kW2a+aeC6hNqBKlwON9TdeWUOXKZpwV+bPilSUPg3kLjuCIgTktkrQ9iTgmb2bV+xM4LZaOh0hPixswHsFTBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420205; c=relaxed/simple;
	bh=QXnyqxG9Ea2F41suhcjEVOVveF5VSYY4UNPDuZ32GpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNEPnlJdujoy/ua9321ectqfplhYexwdNNmuHyVJKOce5Og90WFIC12J4Orvrof865fiW96u/r16i6MuscNoocLbvzxhio24aTw1QBpoa3+Ug0wl3CsQfLZEeyeMk6Z0DEB4hfvKkBj12I8SIxWXC63/7WhJ8coA96XoYXAjDYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWo8kUmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWo8kUmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF64C4CEE2;
	Wed, 23 Apr 2025 14:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420205;
	bh=QXnyqxG9Ea2F41suhcjEVOVveF5VSYY4UNPDuZ32GpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWo8kUmJ3h0IXNlWxjX2YGy9VMBJ4XsQgKC5CYuehxuJHKy/UpCWJ7Ok2o+UpLWuR
	 ehK88BPbypMoKmN5Cmpf/bF8gxOMx5y+p7YaIQaIFXVFlIXWqkJp0KHMuCdbOy/cV5
	 8ix3ihgPCzFfw4Ke6dBu5rIA6KasIBRbQJaDkOaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	xen-devel@lists.xenproject.org,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/393] xen/mcelog: Add __nonstring annotations for unterminated strings
Date: Wed, 23 Apr 2025 16:39:01 +0200
Message-ID: <20250423142645.148655212@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 1c3dfc7c6b0f551fdca3f7c1f1e4c73be8adb17d ]

When a character array without a terminating NUL character has a static
initializer, GCC 15's -Wunterminated-string-initialization will only
warn if the array lacks the "nonstring" attribute[1]. Mark the arrays
with __nonstring to and correctly identify the char array as "not a C
string" and thereby eliminate the warning.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=117178 [1]
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org
Signed-off-by: Kees Cook <kees@kernel.org>
Acked-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250310222234.work.473-kees@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/xen/interface/xen-mca.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/xen/interface/xen-mca.h b/include/xen/interface/xen-mca.h
index 464aa6b3a5f92..1c9afbe8cc260 100644
--- a/include/xen/interface/xen-mca.h
+++ b/include/xen/interface/xen-mca.h
@@ -372,7 +372,7 @@ struct xen_mce {
 #define XEN_MCE_LOG_LEN 32
 
 struct xen_mce_log {
-	char signature[12]; /* "MACHINECHECK" */
+	char signature[12] __nonstring; /* "MACHINECHECK" */
 	unsigned len;	    /* = XEN_MCE_LOG_LEN */
 	unsigned next;
 	unsigned flags;
-- 
2.39.5



