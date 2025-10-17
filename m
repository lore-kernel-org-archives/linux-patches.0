Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D675330B11;
	Fri, 17 Oct 2025 15:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715922; cv=none; b=mjwfk2Eknl2G5mZdHihPVnv8xzYkYK1yBIJ4hXaQR3e4I7pVYAEFi3d69hc26jhW6ghTCSRsY2i4PNNePrcyfz9yw0CzxWJ+6ULSWZohTVWCtBM3aycg6N4/4OcUM3DlfY/OpXxKmYjFWK0yhfX+W8TSj4/3ydi9JRop2dpFErc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715922; c=relaxed/simple;
	bh=6H2oVpAt4wx4iP5PzFnL4qDiKTfIzGVeVrdnmslJnms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8CnARZZtgrNeupHBFDkMottHgGiMNqpOLvgChzTMH+evxME6HLSQf3YG6aKRvigeMNLkttIHZLuPznpr2BnaWuqKfzAyRdZFfDdssHvfyW4a22ir/gLgJiAiCNtIKkFFUYa8xXPHw0ETbwJDuQ5OxBoZWhKCsgXCFqwEgpqdTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFHP96M1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFHP96M1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B392EC4CEE7;
	Fri, 17 Oct 2025 15:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715922;
	bh=6H2oVpAt4wx4iP5PzFnL4qDiKTfIzGVeVrdnmslJnms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFHP96M1BlfVmAWIB2/0t+VK6HlTrA2+sA7BbySec+2wpQs6Lg4vcIqnulyZsR8SH
	 ET8F3yhNXcYtB6HpIFKXlZ7i/8XtenD2FVDWi2r2rGX9eUxNoD4al+w7nnh5RD03Gc
	 gYTSc7Y190P0YfH8GnVROitp43ymehf77rQOO2Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/276] dm-integrity: limit MAX_TAG_SIZE to 255
Date: Fri, 17 Oct 2025 16:51:45 +0200
Message-ID: <20251017145142.848258339@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 77b8e6fbf9848d651f5cb7508f18ad0971f3ffdb ]

MAX_TAG_SIZE was 0x1a8 and it may be truncated in the "bi->metadata_size
= ic->tag_size" assignment. We need to limit it to 255.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index e9d553eea9cd4..8b8babed11f5f 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -124,7 +124,7 @@ struct journal_sector {
 	commit_id_t commit_id;
 };
 
-#define MAX_TAG_SIZE			(JOURNAL_SECTOR_DATA - JOURNAL_MAC_PER_SECTOR - offsetof(struct journal_entry, last_bytes[MAX_SECTORS_PER_BLOCK]))
+#define MAX_TAG_SIZE			255
 
 #define METADATA_PADDING_SECTORS	8
 
-- 
2.51.0



