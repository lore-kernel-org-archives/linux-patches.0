Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060941;
	b=WBFewrZLdleCnExs6f3PXWvIoMhvSLtw1gSRebPVqxwqSBRTPXi1EndJRWbaq0xaw7NM
	 qqF0446QOWmU43SPBlbX7qwXAjHlz1eKOyQg5Lh+q9E9ccVaZ+m1vGMhaFeCvc86Q6lvH
	 ZkKUQxFlLsXAySQ/lqnXE25tezYxiKCeae6QXLyEmDrqYL0ZDBWsoFbAT3XVSiYzl5+0z
	 nXHHw74e0UvjADBSDqL0WEpoFh8NMFkW+cSFNvbv3+u/LSs/LzxrGKXMkZrJ9/ROOx8r4
	 wFk4is4Gy2lno6g9FsreQFQQObEluvMMnkE0eU0FpVuYPEeB8DheMLWtrGJC0tJvdkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PxiMPQVCD7eK7CaifcpGjrPSqaVfuOTCtExfF5Q3TdU=;
	b=EsPuWqULguo4X1o7szw01XfHo/1XhVdoiLyOeK8Wj0VQd8FhCCYJ8R8ITrBgd61gAWg5
	 0SfeKWRyUyjzRjUPAl1FAHzc2XSQhMz59qD8uK2WJ5d4oOO2hlj4P/jBF2+Tat0CGJKZl
	 3ue179+X6NrsBBbPyy/y1uBm8EvrgBP5gsmZ/jrSTc6RXSGzLNuF52xWEI0sZI3lohkqM
	 mZk9SPFS6GOlTMOJu6iO6iVwFIL1aPeeW5B7nSFhk/187Nu9Fud2f2J+7/UNK8ZhjwG9m
	 b+Rrat6wKwKQsIp/IZLOvVfsAAM+GcHhvMmANjSf0Re2OsIqLed0x0gj7hy/+3blJYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qFLw7/Ly";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0F4606A33D;
	Sat,  7 Nov 2026 14:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qFLw7/Ly
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CFD1F0089F;
	Sat,  7 Nov 2026 14:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060941;
	bh=PxiMPQVCD7eK7CaifcpGjrPSqaVfuOTCtExfF5Q3TdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFLw7/LyjQBWnHpCTEbFW4O9gYgfOFtj74pzi7+QimMcRa9ofsORl+oc5Sq2flCh1
	 Q5/JBsBFWrhOY7ir2dHgBj3V9p+6Ps1kvrMF5DCzUoUG3IjPdICH6kYLMS/IqwNN9q
	 K8FMCnx20K7SqK8P7zX4RMVKJuvHKdCCUHRtEB1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0304/1536] fbdev: udlfb: validate vendor descriptor items
Date: Sat,  7 Nov 2026 08:38:40 -0500
Message-ID: <20261107135006.261611498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 3cc2fad376ac7360b4518277aa923752624db59c ]

dlfb_parse_vendor_descriptor() walks key-length-value items inside the
DisplayLink vendor descriptor.

Require each item to contain its key, length and declared value bytes
before reading item-specific fields such as max_area.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/udlfb.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index e51fa67935ec3..8b476a02d48bd 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1586,19 +1586,29 @@ static int dlfb_parse_vendor_descriptor(struct dlfb_data *dlfb,
 		desc += 5; /* the fixed header we've already parsed */
 
 		while (desc < desc_end) {
+			char *value;
 			u8 length;
 			u16 key;
 
-			key = *desc++;
-			key |= (u16)*desc++ << 8;
+			if (desc_end - desc < sizeof(key) + sizeof(length))
+				goto unrecognized;
+
+			key = get_unaligned_le16(desc);
+			desc += sizeof(key);
 			length = *desc++;
 
+			if (length > desc_end - desc)
+				goto unrecognized;
+
+			value = desc;
 			switch (key) {
 			case 0x0200: { /* max_area */
-				u32 max_area = *desc++;
-				max_area |= (u32)*desc++ << 8;
-				max_area |= (u32)*desc++ << 16;
-				max_area |= (u32)*desc++ << 24;
+				u32 max_area;
+
+				if (length < sizeof(max_area))
+					goto unrecognized;
+
+				max_area = get_unaligned_le32(value);
 				dev_warn(&intf->dev,
 					 "DL chip limited to %d pixel modes\n",
 					 max_area);
-- 
2.53.0



