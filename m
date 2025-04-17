Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C8E1D5CCD;
	Thu, 17 Apr 2025 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915321; cv=none; b=Wwa8Egv9hjHpE+Itg1NTNvTtZ3vwi6O8b5QNGEupu2yR2ip0u9yLO5cIJN4I8nkr8Q7CjBKLDpL4UaQUeDo72lTqSaSOs4gnIbQL+9ylpioVQslBI8M8wlJsQ/NNw/bAVeyXFF02Qpj7DyYcVaFA8qNkcMYupJjqDgv+gpb35Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915321; c=relaxed/simple;
	bh=a0lDqeQl1ZQWaF4Qft7Rn4d/dE1IEnaC/8lT0kN4I/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVVgRqJ4o/qBwmuWDDMZ4J2trJM2CkpGG0okdbtJDqwRTu5UjRJ+iHM+YgPs2G0FUNszuZ8oUOBaUYU0drkYzSrobOl4HjbGGqwivUntQP/SN0muMfZQHsYVPdUG8JYY42ox0n7akAg+1f9PjJ2Qmj1myXneqwNfPoWI+/o72yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yiMpfY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yiMpfY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB82C4CEE4;
	Thu, 17 Apr 2025 18:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915321;
	bh=a0lDqeQl1ZQWaF4Qft7Rn4d/dE1IEnaC/8lT0kN4I/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yiMpfY5QwbrCzaYQgVTQ5J+ntCkYpJV0c9NYjBQE02p4wj+5ob1dFfQcQ4os4yKQ
	 XFqV3gzlRIm7wDgqDcOvCo9ijLR0Smhg6f7JyNyPFFZu93PGur5cxEdOrOGshKrOCU
	 ZREuw2ZOeY2LLrQ5e7tysSuDI9AKlAjnK6s3q0TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/393] ASoC: SOF: topology: Use krealloc_array() to replace krealloc()
Date: Thu, 17 Apr 2025 19:47:49 +0200
Message-ID: <20250417175110.008188800@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit a05143a8f713d9ae6abc41141dac52c66fca8b06 ]

Use krealloc_array() to replace krealloc() with multiplication.
krealloc_array() has multiply overflow check, which will be safer.

Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20250117014343.451503-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index b3fca5fd87d68..37ca15cc5728c 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1269,8 +1269,8 @@ static int sof_widget_parse_tokens(struct snd_soc_component *scomp, struct snd_s
 			struct snd_sof_tuple *new_tuples;
 
 			num_tuples += token_list[object_token_list[i]].count * (num_sets - 1);
-			new_tuples = krealloc(swidget->tuples,
-					      sizeof(*new_tuples) * num_tuples, GFP_KERNEL);
+			new_tuples = krealloc_array(swidget->tuples,
+						    num_tuples, sizeof(*new_tuples), GFP_KERNEL);
 			if (!new_tuples) {
 				ret = -ENOMEM;
 				goto err;
-- 
2.39.5



