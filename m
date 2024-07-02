Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9A41BE223;
	Tue,  2 Jul 2024 17:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940580; cv=none; b=lCrIbsuVzIXYMXZNf0xOTKe3ySnNCORHzgt7Vl+faiUyXfH4sTEsh5E2f4OtsquDkq9rpHJLAjFaiiwecn5JIM4x9q4JjqWEv4sZVOFDaPiwwIYKTmDjbqkP9EpKiXskFK5o5ofQU+gEiNreKqWlr5dOPzxxXDIRBLfog5zOPUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940580; c=relaxed/simple;
	bh=VF34eTg2eA9+G4MDSy/4GCd7AdPGfUbsoJ0gh7KqLaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PompTqoBPRDvCQFOSiIkuUN7yA4Y0yE4ryriXuJY7J4JX7axgMgbvqDKXVsFDA229b7NXApeAAXNlxNBHhJjcQ2bHdalhjlVfJb5LYQIM9QKvuVrAAiqo0Kz7YsOMZ9lJ8uUGPaYIsCZCh8YSy8sVZf+h+BM7deRCNlfwE0eDVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUPWrPbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUPWrPbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D40C116B1;
	Tue,  2 Jul 2024 17:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940580;
	bh=VF34eTg2eA9+G4MDSy/4GCd7AdPGfUbsoJ0gh7KqLaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUPWrPbv0H6m0AJDWcPjeEHcoGj4G0Qg4UkQgcwwEPE3CRxV9NsAW9D20NgjBt6d7
	 suLa8dvhCToNrKx9dW2x/6voG/lNO+9HX/NPw4lw+vGTepX8ZJDbU1gw/bMNotHhaL
	 QvfleZK65gHjQYaQoX7Tn+X7mei0jqvoxdKhiK1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.9 198/222] bcachefs: Fix bch2_sb_downgrade_update()
Date: Tue,  2 Jul 2024 19:03:56 +0200
Message-ID: <20240702170251.553030883@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit ddd118ab45e848b1956ef8c8ef84963a554b5b58 upstream.

Missing enum conversion

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/sb-downgrade.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -225,7 +225,7 @@ int bch2_sb_downgrade_update(struct bch_
 
 		dst = (void *) &darray_top(table);
 		dst->version = cpu_to_le16(src->version);
-		dst->recovery_passes[0]	= cpu_to_le64(src->recovery_passes);
+		dst->recovery_passes[0]	= cpu_to_le64(bch2_recovery_passes_to_stable(src->recovery_passes));
 		dst->recovery_passes[1]	= 0;
 		dst->nr_errors		= cpu_to_le16(src->nr_errors);
 		for (unsigned i = 0; i < src->nr_errors; i++)


