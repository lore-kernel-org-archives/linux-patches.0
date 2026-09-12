Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003FC34C155;
	Sat, 12 Sep 2026 14:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223460; cv=none; b=KsXunTThBVyIaLabLSKO3mD5OoY6zzbj6lXvtbMFfB787pcwjZZ6VJPeQ5WGbv7f03gTcVPPxpVdaHfAYgvXo2vBCmHQkk5Ntmxq0dgWL+u5rAzea0Jxj1NKPgK2sgKysUHIByAkyyDxsCmHAAZ22gAguKHjUhQqbZml/Shv80M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223460; c=relaxed/simple;
	bh=0HPIl2GNgdNM7p1riSataN1ZZlRYyUwrgUhHP14Mvm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nN8WU3T6oLbzRee8xStxJYL72jgqITnwtLH8DA3aAokTCyz6cHeSZgNy65O+Znzzr13mLub4VDmMyTMcKYC08IymyPc3i62ZjU9W5CTSAeNH7JaRXIda/3JymA5hQZkuK90oxq1yKjhg8n/8Iz9RQA0FYCAVyGXcghUNP/K79tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1k6XafO4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1k6XafO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7601F000FF;
	Sat, 12 Sep 2026 14:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223458;
	bh=0OweaTcof5t5dlsOPMX0Cwa1zjr9kSmW7TBGbTwyJqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1k6XafO4r7nJhplWLDgjm47MPESaKDeO9WEsRqlrpa2m2KoYMbGBq9xVPmlklN8eJ
	 Jctrsy+q/INKFH6HK82ZXAm8hEb2w0WM0agt++wSoeX4PMonycvJofxFRJ6ubh7SNE
	 +C+4yhp9zhpZ0yUiWpBwq+BEuaBpKoAbLzqaZ4RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0794/1424] accessibility: speakup: Fix incorrect string length computation in report_char_chartab_status()
Date: Sat, 12 Sep 2026 08:53:46 +0200
Message-ID: <20260912065625.078015958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit bce0e640623372520d9d90c42f33ddbfb576ce69 ]

snprintf() returns the "number of characters which *would* be generated for
the given input", not the size *really* generated.

In order to avoid too large values for 'len' (and potential negative
values for "sizeof(buf) - (len - 1)") use scnprintf() instead of
snprintf().

Fixes: c6e3fd22cd53 ("Staging: add speakup to the staging directory")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Reviewed-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20260531230804.254962-5-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accessibility/speakup/kobjects.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/accessibility/speakup/kobjects.c b/drivers/accessibility/speakup/kobjects.c
index a7522d4098025..1eea7c492875a 100644
--- a/drivers/accessibility/speakup/kobjects.c
+++ b/drivers/accessibility/speakup/kobjects.c
@@ -92,9 +92,9 @@ static void report_char_chartab_status(int reset, int received, int used,
 	if (reset) {
 		pr_info("%s reset to defaults\n", object_type[do_characters]);
 	} else if (received) {
-		len = snprintf(buf, sizeof(buf),
-			       " updated %d of %d %s\n",
-			       used, received, object_type[do_characters]);
+		len = scnprintf(buf, sizeof(buf),
+				" updated %d of %d %s\n",
+				used, received, object_type[do_characters]);
 		if (rejected)
 			snprintf(buf + (len - 1), sizeof(buf) - (len - 1),
 				 " with %d reject%s\n",
-- 
2.53.0



