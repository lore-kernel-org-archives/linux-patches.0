Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5CB2ECE94;
	Tue, 17 Jun 2025 16:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176090; cv=none; b=T2+60OR02jdP6dusP/mqIHVQyQZJns23PQSkXqV7puYRtS1IqDFDQHWacNj71K7LjB/OzypAcg3jI6wDv6ySjeKvIG1/x9z2zaFees5dTHnKjePamo0JjW4DheFHg/pXIysQ9nCBVYPK67awOsvmIl697r8L0FNMpv6zcwsULsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176090; c=relaxed/simple;
	bh=hE7C4zxyudq5a9659cZPVBU/HfOKuk4tas+cvubhx3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X63o2ayzQmfMqu80WKY0GhiecgCpDWsKuw2+YElPMlgcExa+vaIoAIgjtsAQgMveCLCCGkQqhsO6e/sgIJn+GTllMjDld7xwoLd9kOInFB98WtdC46KUTHKtpnh2P7jAJOTQ9FEQ6bf2k1ukYefp8KR729q/G1hub7h+TIpKF/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjO7a1DE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjO7a1DE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407BDC4CEE3;
	Tue, 17 Jun 2025 16:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176090;
	bh=hE7C4zxyudq5a9659cZPVBU/HfOKuk4tas+cvubhx3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjO7a1DEP3EjP7oT2SgzoBys/GGmRcTxDnBXRxEs2nwuSYxZmVfq5+8R9KveoF1zV
	 iGagrAlnAsc+OksCCm2IlzS3RnMx3TDi6SBIjqKGUnNG2DkyKZEK0xGOy6QWAJ1cYs
	 RAe1ZCZQfJ/eCgoOgWYnok1lbLi3zlju9q0+5T0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <npitre@baylibre.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 242/356] vt: remove VT_RESIZE and VT_RESIZEX from vt_compat_ioctl()
Date: Tue, 17 Jun 2025 17:25:57 +0200
Message-ID: <20250617152347.950925701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Nicolas Pitre <npitre@baylibre.com>

[ Upstream commit c4c7ead7b86c1e7f11c64915b7e5bb6d2e242691 ]

They are listed amon those cmd values that "treat 'arg' as an integer"
which is wrong. They should instead fall into the default case. Probably
nobody ever relied on that code since 2009 but still.

Fixes: e92166517e3c ("tty: handle VT specific compat ioctls in vt driver")
Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/pr214s15-36r8-6732-2pop-159nq85o48r7@syhkavp.arg
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vt_ioctl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 8c685b5014044..5b21b60547da1 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -1105,8 +1105,6 @@ long vt_compat_ioctl(struct tty_struct *tty,
 	case VT_WAITACTIVE:
 	case VT_RELDISP:
 	case VT_DISALLOCATE:
-	case VT_RESIZE:
-	case VT_RESIZEX:
 		return vt_ioctl(tty, cmd, arg);
 
 	/*
-- 
2.39.5



