Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEC428312F;
	Mon,  9 Feb 2026 14:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648829; cv=none; b=gG7KDJIg7wDixwxdBH174yYMYnRFreIMJwsamUpRypfL547tLSDXWtVBQlAmeaQKlw92MyKyX3Alp35W/9Y6e9Sl+Mcvvt48G1KfFSNX71dyJbB7GmYzKIbNmZCpiZw4QUVeYVE/t6GQaErRhNFNCdeESzli9n6tIGrwGlKdggg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648829; c=relaxed/simple;
	bh=flxGXVby2knBeD8zHmgd+vBB5im3F/fXvyO3WLULiug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KxbQ7be5H/UjwLVz1+84Zj344JDpXAdj8A/Nyc7Z6pfwtO7wG9/j/b+Sd0FhAt6AFDQDvGVjunjE+AodbV4Dtfh4/xzsEudq8d6zE5PUConkO8gL5pAa/I2gfPogEuKYjkvRb3G+HXNZ0rQiJSd9Ja5kifLKlbMgXrZV4Ca+9ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFluciBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFluciBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCF9C116C6;
	Mon,  9 Feb 2026 14:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648829;
	bh=flxGXVby2knBeD8zHmgd+vBB5im3F/fXvyO3WLULiug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFluciBvwOwbhPAruYioya9XGolmPTXldHcEFeAgjqSebWRZMqULXVHJ+ecCe5eGU
	 q/D4Tg8A9Ex44ObUb/HlhkzpJunhSl9uT5fFqqkq4UoVCpe6Gfpostkn4V+vRHlpH3
	 e6GBgziilFyqZc2FVHWlX5u+7PjB069t459F0iYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 5.15 08/75] Documentation: Remove bogus claim about del_timer_sync()
Date: Mon,  9 Feb 2026 15:24:05 +0100
Message-ID: <20260209142302.140104441@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit b0b0aa5d858d4d2fe39a5e4486e0550e858108f6 ]

del_timer_sync() does not return the number of times it tried to delete the
timer which rearms itself. It's clearly documented:

 The function returns whether it has deactivated a pending timer or not.

This part of the documentation is from 2003 where del_timer_sync() really
returned the number of deletion attempts for unknown reasons. The code
was rewritten in 2005, but the documentation was not updated.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Link: https://lore.kernel.org/r/20221123201624.452282769@linutronix.de
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-hacking/locking.rst                    |    3 +--
 Documentation/translations/it_IT/kernel-hacking/locking.rst |    4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/Documentation/kernel-hacking/locking.rst
+++ b/Documentation/kernel-hacking/locking.rst
@@ -1009,8 +1009,7 @@ Another common problem is deleting timer
 calling add_timer() at the end of their timer function).
 Because this is a fairly common case which is prone to races, you should
 use del_timer_sync() (``include/linux/timer.h``) to
-handle this case. It returns the number of times the timer had to be
-deleted before we finally stopped it from adding itself back in.
+handle this case.
 
 Locking Speed
 =============
--- a/Documentation/translations/it_IT/kernel-hacking/locking.rst
+++ b/Documentation/translations/it_IT/kernel-hacking/locking.rst
@@ -1035,9 +1035,7 @@ Un altro problema è l'eliminazione dei
 da soli (chiamando add_timer() alla fine della loro esecuzione).
 Dato che questo è un problema abbastanza comune con una propensione
 alle corse critiche, dovreste usare del_timer_sync()
-(``include/linux/timer.h``) per gestire questo caso. Questa ritorna il
-numero di volte che il temporizzatore è stato interrotto prima che
-fosse in grado di fermarlo senza che si riavviasse.
+(``include/linux/timer.h``) per gestire questo caso.
 
 Velocità della sincronizzazione
 ===============================


