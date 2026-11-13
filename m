Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585988;
	b=Jfwkt2uw9fw5bi/zrhC21dB8eSO88yvq/P2TyZ/O7HoaDU+oJAkxJADiXHDEdkCLGz1g
	 Ff4e7BqKIdckwEmklIcg3IOyBeh39j2ZEwlaBEyEKLNqulPi51iui6dbFIz3gAsejtEJO
	 i91M4wdtO8t95OV4xVouv6XeBfNVS7qC/ZNXdkJlhVaFBvZNxp8ktqa1tYUNOV3ZEK/m4
	 zHO1sRkXIizywVSElNqULHV9DatsBCJLUq9CyO0F2h2Wblrt/eo/DBlYgxZpneGMetVG+
	 tag1sMBke6D3UVXqa6cYWPRQOFAWRzl/JFchxdTUTjqx/ZDhzplLiLh14VBJoY8PlGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sYAVJadcBk1guYOilI3PrmEyMHo9hCVOWd6Ef65FqLc=;
	b=lkfBOpmHJ0YqJj3KoS9v2YQXPoOvH1LQLIEAGEdrZHaBrjllvQi3ziXfL2rPy1Tm2j5N
	 +lItojH7qGc7/HCl4ACZ648QJeRPwCZFxVRuBevJ2+qNAb6YvR4YmuOZJ46YeUf3efIvt
	 0C3sfFHMQFRSek9BUZHiTAPBx3LdfxFsX1OKjfWPYkiLpma7JOxBy6eSvTqERXja1aW+T
	 W2o5rtByIjj7ooGXx7VD+KOQolObPbtcHJUXHXCc7d+GGVvAzVpherVF1GPTOx4qlRpq3
	 j227is4jWB8HLpwGJ+i9EQFJDChvvqTiJInJF0mjWHh1CxF/4J8l1uZNDSgncdVLByQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HcB1ScZ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA9C6072336;
	Fri, 13 Nov 2026 16:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HcB1ScZ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE06B1F000C6;
	Fri, 13 Nov 2026 16:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585988;
	bh=sYAVJadcBk1guYOilI3PrmEyMHo9hCVOWd6Ef65FqLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcB1ScZ2jXR4WJ8qgBQaknv9qAi2b06iDm5LXpXyuumKdFiou5lwPn0esKfVCOyxb
	 WaEiHiuPchusTGgTtnT/GvzUv/x8jhYkd8LVBfBPcYwLDZ7bu4KXSzPjtgCL2XPfB/
	 1Otv6Q7ZZ52jI3UtTwTYh77BLXVDMPDDEu+nF/mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/686] smb: align durable reconnect v2 context to 8 byte boundary
Date: Fri, 13 Nov 2026 10:42:45 -0500
Message-ID: <20261113153822.072618554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bharath SM <bharathsm@microsoft.com>

[ Upstream commit 05f5e355cf783b30bd6eb3dec17ed1a8b3cfa95c ]

Add a 4-byte Pad to create_durable_handle_reconnect_v2 so the DH2C
create context is 8 byte aligned.
This avoids malformed CREATE contexts on reconnect.
Recent change removed this Padding, adding it back.

Fixes: 81a45de432c6 ("smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h")

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smb2pdu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 7377b5a9f8a55..4b8ed28a72c61 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1320,6 +1320,7 @@ struct create_durable_handle_reconnect_v2 {
 	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	struct durable_reconnect_context_v2 dcontext;
+	__u8 Pad[4];
 } __packed;
 
 /* See MS-SMB2 2.2.14.2.12 */
-- 
2.53.0



