Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACF01DC998;
	Tue, 27 May 2025 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367504; cv=none; b=JbrxqrToAdR0zkyF4cBn4j2Xl9T7NDZ7i+Nk1T8H0okB3sftXVLEzi9vrye/3YmJM7/7RyB0aGbKVWFPlXgvi5e4Qt1T5S/VVQZmdGmmCT/6bTj7OZtzoXpDufAFHIdVXA4q2fZOqubbjJB6XcpYgxpr2kP9r1aQAVACyIf39C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367504; c=relaxed/simple;
	bh=SOx8Y0c088ujViRSAOAeD1J9d6F6ok8rHoZFrynY3fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PjctCqbGjRStTgx0A7FkFbJkRArr5DNioXq907aiNi+sdZJOhqJKLX43iawdI7dk4SUZO6DyWU7pt6yoIahNWfDmgDQHd6qKJLrGAF4nFuTunJzDdzZ461cu2ysjFxcUKQ85nGZ68/x5TxviE1PjK1cYL9nFftIDa2VN3xY6dVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mq7DE+A2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mq7DE+A2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6173AC4CEE9;
	Tue, 27 May 2025 17:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367504;
	bh=SOx8Y0c088ujViRSAOAeD1J9d6F6ok8rHoZFrynY3fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mq7DE+A2dJ31W7dUazUag+y0zhe7DjZceupANK0ajh2GHSmR0fmUidKMk8IdBapSM
	 d29tO52NmoBBYDAiIoHwowiCZKX0VYiZjZ56tt3/bJR1/mHi8McUzfaukHQgWgdDel
	 2ExjM0UbH7Ka6ql1mwIWbAWcVvoM+n1mVShh/FLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 408/783] drm/xe/client: Skip show_run_ticks if unable to read timestamp
Date: Tue, 27 May 2025 18:23:25 +0200
Message-ID: <20250527162529.717874752@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>

[ Upstream commit 94030a1d3283251778411cf74553607a65260f78 ]

RING_TIMESTAMP registers are inaccessible in VF mode.
Without drm-total-cycles-*, other keys provide little value.
Skip all optional "run_ticks" keys in this case.

Signed-off-by: Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Michał Winiarski <michal.winiarski@intel.com>
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250205191644.2550879-3-marcin.bernatowicz@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_drm_client.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_drm_client.c b/drivers/gpu/drm/xe/xe_drm_client.c
index 2d4874d2b9225..31f688e953d7b 100644
--- a/drivers/gpu/drm/xe/xe_drm_client.c
+++ b/drivers/gpu/drm/xe/xe_drm_client.c
@@ -324,6 +324,14 @@ static void show_run_ticks(struct drm_printer *p, struct drm_file *file)
 	u64 gpu_timestamp;
 	unsigned int fw_ref;
 
+	/*
+	 * RING_TIMESTAMP registers are inaccessible in VF mode.
+	 * Without drm-total-cycles-*, other keys provide little value.
+	 * Show all or none of the optional "run_ticks" keys in this case.
+	 */
+	if (IS_SRIOV_VF(xe))
+		return;
+
 	/*
 	 * Wait for any exec queue going away: their cycles will get updated on
 	 * context switch out, so wait for that to happen
-- 
2.39.5



