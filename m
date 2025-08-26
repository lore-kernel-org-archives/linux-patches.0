Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C161FBCB1;
	Tue, 26 Aug 2025 13:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213222; cv=none; b=OjLCZ8zNqm5PVW/1gcour4ZJYsHPfKEVN+fW/vm6DqJKWXqysj8Nudx4+eYCMMzWGGfhtg5MXzu6wrJ5Qfo4fDySVq6SX8kxX5ComNX9r4kUOvR5nHgOiw5kdRTaVVj8pLyQzi5whgxEtmnFJu7qsj6zm+1y2flWfbJ7tMWd8Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213222; c=relaxed/simple;
	bh=QfgT9QgrPmp0YJZ3PyDO4ebJO+ZKrheFIHvjN8vKEL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOjLkBGZtFltg2igVfVvQ96r4Q+HXKsPZX4rMfH06fjK2jtpZXXDhAa3Us87oh5kkT1hAiUJsArQLjC9AqjNrHzh1Cc5Cje6/PyXwbM3ca6tywrW1nSEPw45aXWyr3oTAu0ykcGI2PNcsbjSBi06kKEsdYgTPcI8E55kxOWjhQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nScpUUHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nScpUUHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07095C4CEF1;
	Tue, 26 Aug 2025 13:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213222;
	bh=QfgT9QgrPmp0YJZ3PyDO4ebJO+ZKrheFIHvjN8vKEL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nScpUUHoBIra6cKKfDV7bnl7jNf0qTotjYBN8eOk/BPuVnrY8uwak5PTZVolqhewd
	 LSDHLzSmfkIedWvF+0ipm5ss8jk08FdQVVMO4Ej9g3m1I5Z59gLQGkl7TwfkDZzoiP
	 K6QiT4XPGJDJ5c3S3PkmsK43EzW9pJXzo1L/Q+wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Marques <jorge.marques@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 267/587] i3c: master: Initialize ret in i3c_i2c_notifier_call()
Date: Tue, 26 Aug 2025 13:06:56 +0200
Message-ID: <20250826110959.719460587@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Jorge Marques <jorge.marques@analog.com>

[ Upstream commit 290ce8b2d0745e45a3155268184523a8c75996f1 ]

Set ret to -EINVAL if i3c_i2c_notifier_call() receives an invalid
action, resolving uninitialized warning.

Signed-off-by: Jorge Marques <jorge.marques@analog.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250622-i3c-master-ret-uninitialized-v1-1-aabb5625c932@analog.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 7e526da11524..b6995e767850 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2430,6 +2430,8 @@ static int i3c_i2c_notifier_call(struct notifier_block *nb, unsigned long action
 	case BUS_NOTIFY_DEL_DEVICE:
 		ret = i3c_master_i2c_detach(adap, client);
 		break;
+	default:
+		ret = -EINVAL;
 	}
 	i3c_bus_maintenance_unlock(&master->bus);
 
-- 
2.39.5



