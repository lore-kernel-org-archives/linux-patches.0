Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D7B1AED31;
	Thu,  6 Jun 2024 14:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683342; cv=none; b=Smnd1GTnRlmT7dICx9Y5D6UzaB95YiKKqPFVzTDMuYUQO4hFsQep/k+zoAflWBPMOvoy4PMnJ3XIiMAe/Pd10x6J3UH/0djHfbUvGzCSkCvDUmvzIRA6E3HClE0k/3kMfCsHxLLxJrvuddZbdAxdnGaklch/s4dhyeNKN3ybim0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683342; c=relaxed/simple;
	bh=oa1EteXfyaV59KUdQCypBRGG91n5XjLLYIVxQyYFG04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSS29ivCYpd73c46W8en2KPYOmgNW2a6rEVos2KFaPjURzk5A74n8Xj8Hmfsl0Upk/sjnmvA6aUYQ6XFPEFqAPvpQqsw7ZFQW0M7bF8QP2qYhGBu6wgMlfHYodzQ3MAadSi8RQLrUxIh6AFNWma+1j0iPI5K0yowYHjhR8Xin5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaiHvLnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaiHvLnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D086AC2BD10;
	Thu,  6 Jun 2024 14:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683341;
	bh=oa1EteXfyaV59KUdQCypBRGG91n5XjLLYIVxQyYFG04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vaiHvLnlV9WcnGnqIptnd9sYnJJVhOeRs5IzOARxOI1bSXKc0U0q+o6Lg7DXRniFE
	 zCotdAOum/lg5XvnrbKGhmqLqfrCuXQmFXMnTKRt4WpZYgTmN4CtGnVMIifIqOQVci
	 DDLvGDMBR93HnlUnxHQ/pY0H47mIMDTmywTPydvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 223/473] ASoC: tracing: Export SND_SOC_DAPM_DIR_OUT to its value
Date: Thu,  6 Jun 2024 16:02:32 +0200
Message-ID: <20240606131707.254970510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 58300f8d6a48e58d1843199be743f819e2791ea3 ]

The string SND_SOC_DAPM_DIR_OUT is printed in the snd_soc_dapm_path trace
event instead of its value:

   (((REC->path_dir) == SND_SOC_DAPM_DIR_OUT) ? "->" : "<-")

User space cannot parse this, as it has no idea what SND_SOC_DAPM_DIR_OUT
is. Use TRACE_DEFINE_ENUM() to convert it to its value:

   (((REC->path_dir) == 1) ? "->" : "<-")

So that user space tools, such as perf and trace-cmd, can parse it
correctly.

Reported-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Fixes: 6e588a0d839b5 ("ASoC: dapm: Consolidate path trace events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://lore.kernel.org/r/20240416000303.04670cdf@rorschach.local.home
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/asoc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/trace/events/asoc.h b/include/trace/events/asoc.h
index 4d8ef71090af1..97a434d021356 100644
--- a/include/trace/events/asoc.h
+++ b/include/trace/events/asoc.h
@@ -12,6 +12,8 @@
 #define DAPM_DIRECT "(direct)"
 #define DAPM_ARROW(dir) (((dir) == SND_SOC_DAPM_DIR_OUT) ? "->" : "<-")
 
+TRACE_DEFINE_ENUM(SND_SOC_DAPM_DIR_OUT);
+
 struct snd_soc_jack;
 struct snd_soc_card;
 struct snd_soc_dapm_widget;
-- 
2.43.0



