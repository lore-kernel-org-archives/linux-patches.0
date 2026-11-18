Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059140;
	b=twJ3WH1nIE3bFiNEIhvNa6p7VY9CweXM19SRers+n/DHMrOPEcoJQqtiAR0faoSYwqvA
	 clBl6OBHoUIk29MuRe5Aa9Ci+ID9CymRWeIfNEj/2rw215EQ9N4C+cCwswbRV9W6pO6pM
	 qivjMcHHB5wXNZnXswEw66/x2AL1D9fPlNr/KtHSiSeI76G/6yOr2aq0h4RJ2wa3og6ML
	 YXB5vWzDrpgmhou7KjQMEnL8mVPjKI2IrNLrFH35cvZ0nmZTRrwB/GMxnX+PuaisU/wBH
	 ORLtq+JHtk6/zpfKYH0BPUvrX3rHn/fgm1XMxtt+bsY3SD6UuphsEs5qdFMny50cd+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v3y6MJtvBFBklbbxNoqZUvpfr9B68LSY0ZYvT+4PzBg=;
	b=KqRw96ttJfzL2Fc6AIWr6yTbaqkcZ0hwvbweVvrvxqgYI+Zm5NEFeGKx34k39ZoZl2m2
	 jqCpwTaPSwecIfYx9w7VsHXT6JsXUjYW/oUN0U6q3h4Wv8b3AQ4taBhOSEnpM+G48zUNY
	 wORAoFthmMBRSXZ7NvPCrjbD8M4R75VLOoAtIy3mIjt6R0HERN4OhV+fq7zwvj0Trfhvb
	 NklLX27NuzjrAzJQTjOjo7j16wqmwiCuNwWxZqfmpir0muVL7mWvObGmwHYMKKi88vy6Z
	 m0sfIwxTd4yEvuw4yzI4q0dOVd9PR4IABaud75ibcrHURUTOsaPAQXoITDuMFV0s5Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ENJUusOw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7540F606A32F;
	Thu, 19 Nov 2026 03:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ENJUusOw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74791F000C5;
	Thu, 19 Nov 2026 03:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059140;
	bh=v3y6MJtvBFBklbbxNoqZUvpfr9B68LSY0ZYvT+4PzBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ENJUusOwv2Dv5RXF0ioel+9PD1um8HHa6bXhvphNkcgj9NZzWVdUwSqRJYACXnsfS
	 7JMIV31JaXfhDuWlOBT475pOCtQ0cCQcjvoyZ+6Rr56d2BFfPZ2KtBByHIKvpAYEvg
	 N4Fn5CenORr3un0vDJXOMKLx/32OikTIoab77ghc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ewan D. Milne" <emilne@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0736/1848] nvmet: dont return memory contents beyond valid data when reading ANA log page
Date: Wed, 18 Nov 2026 15:46:14 +0100
Message-ID: <20261118145947.123618031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ewan D. Milne <emilne@redhat.com>

[ Upstream commit 29b8758b4700357909f06705a0c48c7a60c556d5 ]

The host side does not know how much valid data will be returned by the target
so it will typically provide a buffer larger than the amount of valid data in
the ANA log page.  The memory allocation used by the target does not guarantee
that prior kernel memory contents will not be returned past the end of the valid
page data.  Fix this to ensure that the SGL is zeroed before copying the data.

Fixes: 72efd25dcf4f ("nvmet: add minimal ANA support")
Cc: stable@vger.kernel.org
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 6a8274caa3bc7..835ff574f80b9 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -254,6 +254,15 @@ static void nvmet_execute_get_log_page_ana(struct nvmet_req *req)
 	u16 ngrps = 0;
 	u16 status;
 
+	/*
+	 * The header and one descriptor per enabled group are the only bytes
+	 * written below; zero the whole transfer first so the unwritten tail
+	 * does not leak stale kernel memory to the host.
+	 */
+	status = nvmet_zero_sgl(req, 0, req->transfer_len);
+	if (status)
+		goto out;
+
 	status = NVME_SC_INTERNAL;
 	desc = kmalloc(sizeof(struct nvme_ana_group_desc) +
 			NVMET_MAX_NAMESPACES * sizeof(__le32), GFP_KERNEL);
-- 
2.53.0



