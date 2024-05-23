Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A251D545;
	Thu, 23 May 2024 13:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470720; cv=none; b=W2btomxR4/Cs3m+jJ869EjR2gpOSs3UZW2tUGjG4TMUB48thmxu1VXeiciD1NIaOflkTL/mJSek6z8g3Nir0mhm5n2eJJCzzMa6wH9EdxX0kUJS5X+3TnkjIvKN3wrj2Y0b+CKTr+sLbjqykDXRwnFrq8sW4Ftm7ilVId0EssSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470720; c=relaxed/simple;
	bh=sn6BY9OBXK3JfzOURmDtv/aUi4e5dr+Lbzvm0LL+tZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6iG/2NVumdDkLdii2jfea4Eiq3Yd1N+7V+dDKj6D1ZOoZ9CwNdUHhqwyQRFS1XgcOmJ+MvYwgzphjmIQGhYG8eXy3ajzTcVqorm6bVy90ulhXTyNTiycizfEpjILIoP5gdAHHygdZzhNvIw1es9OuH7z0UjTBJ6f35hs1TtcD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irQWAiTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irQWAiTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E127C3277B;
	Thu, 23 May 2024 13:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470720;
	bh=sn6BY9OBXK3JfzOURmDtv/aUi4e5dr+Lbzvm0LL+tZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irQWAiTqX7N0lKn3dnhn5R1Yd8GctqRTU7p5dybGRDcbpWqSaJCSmPaRKubevJlU+
	 vBg/C+8DWfZATi/fEGGrcs8KSXyNdVpRaRcj/a4dgLvAodySMhLbtjU+tNifHctW/a
	 Fx/Bw5rjVuinhRXQ64op1DzBTSxbECFOJ8cX6OK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/102] ksmbd: Fix spelling mistake "connction" -> "connection"
Date: Thu, 23 May 2024 15:13:30 +0200
Message-ID: <20240523130344.923042473@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit e758fa6956cbc873e4819ec3dd97cfd05a4c147e ]

There is a spelling mistake in a ksmbd_debug debug message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 58bafe23ded9a..b7adb6549aa0f 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1856,7 +1856,7 @@ int smb2_check_durable_oplock(struct ksmbd_conn *conn,
 
 	if (memcmp(conn->ClientGUID, fp->client_guid,
 				SMB2_CLIENT_GUID_SIZE)) {
-		ksmbd_debug(SMB, "Client guid of fp is not equal to the one of connction\n");
+		ksmbd_debug(SMB, "Client guid of fp is not equal to the one of connection\n");
 		ret = -EBADF;
 		goto out;
 	}
-- 
2.43.0



