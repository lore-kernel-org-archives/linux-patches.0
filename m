Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E611E103C;
	Wed,  6 Nov 2024 13:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898387; cv=none; b=o/GQraIjwf47a2fM0rEUaUj/awUzml3Cv6j+0eryRtrtMnMEHX3PonoRS5VKCXRk7/Tr9PVWBjVriH6nIQQnaWosx8r7oolQoOU7Tfnz/vqrchYYVRV12NzAznqZSvi0tLxH09rN+euqszAYVJQaJwSpPJ3STe0eSq1QPN12JBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898387; c=relaxed/simple;
	bh=cGqmj7sVSuhlAUgPkl9AGLz/OOxyserceT0Rp6Gh/NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWHJdRb8YBRq+p2BqI72KsveFn5QOgCqX2+nwv3A1BP+HK7yezt72k9y3wYovplmlVX599+pVbFItxePyle2AvWsSfssg+SEsEpHcCiDBn/YLz4odJ1xv4a5AGyLyiq3Ru2vg9YUcgIgvD7E+eacTQwjpoDENhM7QsMdEaA95T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nc4NB7A8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nc4NB7A8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A75FC4CECD;
	Wed,  6 Nov 2024 13:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898387;
	bh=cGqmj7sVSuhlAUgPkl9AGLz/OOxyserceT0Rp6Gh/NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nc4NB7A8AFROunGl7jAgksfqKX39sR7belW0yLfC8GWGZS0xvcFhHW9o9G6RP/m6V
	 tdzG3dAVXOZvrIUFzUBsIzJaEF+19FlQ8nRHpmi7NbbesiCevjoAVNUxNsrpuFgJw9
	 LmvF0f6vMfIbuE5e5Q15d6YpOdtraAPJe0gCf2sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 220/462] power: reset: brcmstb: Do not go into infinite loop if reset fails
Date: Wed,  6 Nov 2024 13:01:53 +0100
Message-ID: <20241106120336.955934507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davis <afd@ti.com>

[ Upstream commit cf8c39b00e982fa506b16f9d76657838c09150cb ]

There may be other backup reset methods available, do not halt
here so that other reset methods can be tried.

Signed-off-by: Andrew Davis <afd@ti.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20240610142836.168603-5-afd@ti.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/brcmstb-reboot.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/power/reset/brcmstb-reboot.c b/drivers/power/reset/brcmstb-reboot.c
index 884b53c483c09..9f8b9e5cad93a 100644
--- a/drivers/power/reset/brcmstb-reboot.c
+++ b/drivers/power/reset/brcmstb-reboot.c
@@ -72,9 +72,6 @@ static int brcmstb_restart_handler(struct notifier_block *this,
 		return NOTIFY_DONE;
 	}
 
-	while (1)
-		;
-
 	return NOTIFY_DONE;
 }
 
-- 
2.43.0



