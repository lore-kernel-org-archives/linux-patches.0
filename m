Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F9B1CCEE7;
	Tue, 20 May 2025 14:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750150; cv=none; b=ogA7fpft5XtOeYjb6BHEnUB4L74iTM4R0HBheN+ARX3Z3jnUWv9cq7r9+QsPbv3O1VOOVLqI/hxJkBFqIo4xvWsu1feaTrx9jScjBqY46m4Kr8KzR15PRNotmJ/CNV4iwattPxt7nNId9/rTqiUtQRLxLlPgVGsi+jKElF32fzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750150; c=relaxed/simple;
	bh=a0OQxEgWjBNnXK6WLQRm+oKF3E+VxdQc17fB33kUg0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkgF5fEoyKJcv9LHLA5gDfYKe7ULRWM9+omstMDWsbYQcmTMjQvm8pwzoq9LBQQFmGZT+9N3AbZMnfBxZV2JqB0/m8YRWx2rIqBREV2BA1r9vyzfrGBLkqMlCIUqlpMoOleEkF+ZOzNSBAx3GY31/6KwdQomv3mUvkIRFIxtWos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+plly92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+plly92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3010C4CEE9;
	Tue, 20 May 2025 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750150;
	bh=a0OQxEgWjBNnXK6WLQRm+oKF3E+VxdQc17fB33kUg0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+plly92lKNn4SYJljVlHPHk/wxzxaHZciPKIOZjZ/G3Zl4SByLQe6LIaEMLPwxII
	 NrbR2dJV0Az135ukNd1dtopzVVkjGmkiDgxojuQG5kDW4IUliq+YKcW8U3NmJ1dNGK
	 ph9ADzeFhlbHIJwmylVnfKg/RB5AYMrGNNZWU9T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/143] netlink: specs: tc: fix a couple of attribute names
Date: Tue, 20 May 2025 15:50:13 +0200
Message-ID: <20250520125812.336273874@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a9fb87b8b86918e34ef6bf3316311f41bc1a5b1f ]

Fix up spelling of two attribute names. These are clearly typoes
and will prevent C codegen from working. Let's treat this as
a fix to get the correction into users' hands ASAP, and prevent
anyone depending on the wrong names.

Fixes: a1bcfde83669 ("doc/netlink/specs: Add a spec for tc")
Link: https://patch.msgid.link/20250513221316.841700-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/tc.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/tc.yaml b/Documentation/netlink/specs/tc.yaml
index b02d59a0349c4..a5bde25c89e52 100644
--- a/Documentation/netlink/specs/tc.yaml
+++ b/Documentation/netlink/specs/tc.yaml
@@ -2745,7 +2745,7 @@ attribute-sets:
         type: u16
         byte-order: big-endian
       -
-        name: key-l2-tpv3-sid
+        name: key-l2tpv3-sid
         type: u32
         byte-order: big-endian
       -
@@ -3504,7 +3504,7 @@ attribute-sets:
         name: rate64
         type: u64
       -
-        name: prate4
+        name: prate64
         type: u64
       -
         name: burst
-- 
2.39.5



