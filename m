Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8866242049;
	Thu, 15 Jan 2026 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496046; cv=none; b=qOTL6LdbV+Q7WMVKkqvna7cTqSpcxOOTKYWUWQVovcccnqTiHocoooThKhDaIOiOLIFMNr1VddoFlFJEVH+4UsO7pYoj4NG9MXk7TzbPigrVKsCZOCBnV4D5mXJkBk75HGsdFAIjdHSZDTnPXslgmyGSQRDLFgHN9bP4YQZSBEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496046; c=relaxed/simple;
	bh=OlvssYidrTBiVPBFekt/En43vQEc8oqVmifSU8DUGOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejlzsx3tjROK6VWjDo3OyS5rlDRB/OWeyMQ9VW6i2CeYnKEwOiU0cqf1GBAcI6dWafG8qJBx4FtJlcNSqdkCJTvBdkhIgF1wnat91YC57BubCNlcivKDRK30QPfIFatH/x6cfPIg916decmfZ+Sofj2WT9OGUZ/0TQnMYycNd/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTxcy1rY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTxcy1rY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11952C116D0;
	Thu, 15 Jan 2026 16:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496046;
	bh=OlvssYidrTBiVPBFekt/En43vQEc8oqVmifSU8DUGOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTxcy1rYipmdQSTNuvIarFolcrfW0ijtLLRzIp+yaTa8cLWpqY3gS43ZBaCOBuM2g
	 lXX8C/4jga9GzM5VC2F3CrIu3KI/4Khu8ewJWl186f/4UC8LWAvQH8J/JN6X9f8V1R
	 kdqM4xg6O5PeDKe77HO3T7xiRkau6Lym4NFskIRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/181] smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
Date: Thu, 15 Jan 2026 17:46:35 +0100
Message-ID: <20260115164204.421499962@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit b2b50fca34da5ec231008edba798ddf92986bd7f ]

This was reported by the KUnit tests in the later patches.

See MS-ERREF 2.3.1 STATUS_DEVICE_DOOR_OPEN. Keep it consistent with the
value in the documentation.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/nterr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index e3a607b45e719..b3516c71cff77 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -44,7 +44,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_NO_DATA_DETECTED 0x8000001c
 #define NT_STATUS_STOPPED_ON_SYMLINK 0x8000002d
 #define NT_STATUS_DEVICE_REQUIRES_CLEANING 0x80000288
-#define NT_STATUS_DEVICE_DOOR_OPEN 0x80000288
+#define NT_STATUS_DEVICE_DOOR_OPEN 0x80000289
 #define NT_STATUS_UNSUCCESSFUL 0xC0000000 | 0x0001
 #define NT_STATUS_NOT_IMPLEMENTED 0xC0000000 | 0x0002
 #define NT_STATUS_INVALID_INFO_CLASS 0xC0000000 | 0x0003
-- 
2.51.0



