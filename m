Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015530;
	b=0wQTB2kcusncoKk42oiOlsbJTjBEBYWaxJkjSLTW9RNlTg+qOs7z+Bs6xb8Sqb0fqgxw
	 DhQxBkDFRzVPQD7I5NeYETAcAaRxlsXYx00mdqvUzyEhmRlKjLopUfxNy3FMEjoczdsCG
	 bo/3DJO1heUh/SUc0vWA2bxD5UozSUxnkdMbkhI5WJPMNDiflApdmXrbe0Y00qYnOHnWQ
	 pqDUtGzxuA16FeC/PDC/KWHkaJNld9/ZjwRBA66DP5JuH9g2vWU+fJmSoKEb2sg5GX2Sn
	 ++qQg5ByyDmwIdk1QeSjkgqVR2MuyUryfW6MukeN3GRDZBERSB3o3quGz2RQeiKniUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pkR1LcMMQyldB+4zknmZuHgCLrLH5GVnwZ3q0NE7wGE=;
	b=UjJQYW+DIACnTrXZmeo0zyOH28cbuhhhHFRlw2n7PpnrxxIPzFyOWGiBKfN2NAgWSPN7
	 hlVa9g1IfIyVvutoKaHFIEXgwVToPHiCwm4sUngnkkZzsd+jrzhDHDF8a/QxJOsDhLpgS
	 W9vSQz4iA4ExWkqhyn+hn1z7qqddcUm9HDzeXoAUoj3aI8RYZG+NBFzoz/ru45R3cLvot
	 DlHO2R0milV2ZdTZzA2i9qGL9F5AXC50Yrm1cy0VyQSYLsYwXKEBHKe+bUHYLY/V6ewqZ
	 m5yioP9yKRckmRRW5cJ1TBB4c52epgL2LfvwLChoY8NBhugoEYA1IugwCP4qLi7bcew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ud5vd6p/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E839960A2610;
	Wed, 18 Nov 2026 15:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ud5vd6p/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E8D1F000C4;
	Wed, 18 Nov 2026 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015529;
	bh=pkR1LcMMQyldB+4zknmZuHgCLrLH5GVnwZ3q0NE7wGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ud5vd6p/EHV1di6vW7eZRv/ItlXKx3pEs16vLLjxdHzVlbxpFGukWeziaTQVzzskd
	 o6UoWmIs9qRnwt9V8D3P54uiwjJDzLPkaNIGk4IikXyl4jq02gr2yHNerYHNePlKpU
	 sivHST7SmunQwapx01CjFaKlNkIUpxbK0435YW+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0165/2651] wifi: mm81x: do not discard a failed firmware segment write
Date: Wed, 18 Nov 2026 15:23:25 +0100
Message-ID: <20261118150253.793561386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit dc1936211335eca00acca53d058dc94fbab02028 ]

When mm81x_dm_write() fails while downloading a PT_LOAD segment,
mm81x_fw_load_fw() sets ret to -EIO and breaks out of the loop.  The
boot address write at the end of the function then overwrites ret, so a
partially downloaded image is reported as loaded and the chip is
triggered on it instead of the load being retried.

Leave the function as soon as a segment fails.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260812060740.1275280-3-lilinmao@kylinos.cn
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/morsemicro/mm81x/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/fw.c b/drivers/net/wireless/morsemicro/mm81x/fw.c
index d407b57f4c9cb..a2cb97cefc4e9 100644
--- a/drivers/net/wireless/morsemicro/mm81x/fw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/fw.c
@@ -162,7 +162,7 @@ static int mm81x_fw_load_fw(struct mm81x *mors, const struct firmware *fw)
 			mm81x_release_bus(mors);
 			if (status) {
 				ret = -EIO;
-				break;
+				goto out_free;
 			}
 		}
 	}
-- 
2.53.0



