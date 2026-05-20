Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E35348C55;
	Wed, 20 May 2026 18:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301266; cv=none; b=OqwL7wfJq1xKbsGo23XNz8Qsr6gp0ukCvm8BWb2t5qcDdQLVARpXcrNBHh8QH9tg85euq7krm07lnhH9p5zySDYEpP7CJ0lnoG6Z7KEJN+Xm423P/hoYQh4HOQ7QLENL3Ji235Gz6M2kzhyKeCB89254FU0QUd1JazeGR81CBxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301266; c=relaxed/simple;
	bh=dGbl8jY6heI4UkrHDPKz65u5MSQiOp9KN8+zHlO6smU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7q0oKCai0lLb/bbz0BepSbt5JDchg8Gwo8A2LiDgKKv9sPjEZnkcfoBzdGXia/4v8E3T03wUlkc6uIFyzQ1ZItqVdTreZXdt/2OGkDPrmKBn3D0ICjGRWf+zGSx2BvcM5LpV6GvCbXOf9Dys79Bgo61ycq+6oJaTpw6ixYOELQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkhSChXK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkhSChXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8631F000E9;
	Wed, 20 May 2026 18:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301264;
	bh=4I6Ldr75966T8qjqqL435uFnm4AdGHwlxe6exhFc5rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkhSChXKHqMgEIEsnpJ5UppXkKaZjbalHe7StzZqdzoBlBB+siw1O93U3IQnQNTde
	 KM6etdwHY6kPbcxWRITn9M2/Gdzthp8ZfuLUPXftK+u0f91oXXJ8yzDwJQAOZrU9iA
	 ewrmwZwhRbinJq4ZrtIO+a0fXhRw33P8PQ5Xh7qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdulkader Alrezej <alrazj.abdulkader@gmail.com>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 490/666] net: dsa: realtek: rtl8365mb: fix mode mask calculation
Date: Wed, 20 May 2026 18:21:41 +0200
Message-ID: <20260520162121.884446793@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mieczyslaw Nalewaj <namiltd@yahoo.com>

[ Upstream commit 0c078021d3861966614d5e594ee03587f0c9e74d ]

The RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK macro was shifting
the 4-bit mask (0xF) by only (_extint % 2) bits instead of
(_extint % 2) * 4. This caused the mask to overlap with the adjacent
nibble when configuring odd-numbered external interfaces, selecting
the wrong bits entirely.

Align the shift calculation with the existing ...MODE_OFFSET macro.

Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
Signed-off-by: Abdulkader Alrezej <alrazj.abdulkader@gmail.com>
Signed-off-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Reviewed-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://patch.msgid.link/400a6387-a444-4576-af6d-26be5410bce3@yahoo.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 4cb986988f1ad..9621fa4052f84 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -216,7 +216,7 @@
 		 (_extint) == 2 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1 : \
 		 0x0)
 #define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(_extint) \
-		(0xF << (((_extint) % 2)))
+		(0xF << (((_extint) % 2) * 4))
 #define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(_extint) \
 		(((_extint) % 2) * 4)
 
-- 
2.53.0



