Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DC33FE2D;
	Mon,  1 Apr 2024 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986609; cv=none; b=jJ78eiUUIN9IH60cUH/XPoYN+9Pz+f16zAGoPnT0o8jdXp9nWHdrm7y6X/O517qK/Faa/vK/HJCBjBfb3TSv0klnjh6tNcxsZb2bezqMY07Rgh4KyjBF8zrOY84JPx6zq8TuaMXPM3DF+G5hNDBEoD/Q54mOQAthI0w9xI3xPu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986609; c=relaxed/simple;
	bh=ykvsoD1fYfmtwyqhyvY3iCCeHZfBs5pZ0971hctMzJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugCYTngdsP41TZ0KhQVvZuVn6OgfP5jR0z5qFXGENFTzk5Ctqx2RP0gf2Jk5Np9wnOplpd7koEtgH6a7DnEgiQCLlCnGC7hZHXWjjI4RKfPpFk5JI6eo+UeTofh0Hzr6vurBsiemAkuRkdvmbDmp4XmJRulDmk/dMdCKeiAaehw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHXze4Y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHXze4Y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E525C43390;
	Mon,  1 Apr 2024 15:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986608;
	bh=ykvsoD1fYfmtwyqhyvY3iCCeHZfBs5pZ0971hctMzJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHXze4Y0aMVbQ+VTEQ1Ba88wayuM5UgQnyzURaV4bUOrIBWpTuf7La1D/nOjv/tFU
	 B+idIDfgl2R3qZpjCrE8/9+REFqgTG8MsNxm+21u8i3gzJxO1kfPODFmpP11FAMB7o
	 6F0jeIW378opKELNbB06BORTSQo3WnZfQauaRsAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Perry Yuan <Perry.Yuan@amd.com>,
	Tor Vic <torvic9@mailbox.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 028/399] cpufreq: amd-pstate: Fix min_perf assignment in amd_pstate_adjust_perf()
Date: Mon,  1 Apr 2024 17:39:54 +0200
Message-ID: <20240401152550.003044237@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tor Vic <torvic9@mailbox.org>

[ Upstream commit b26ffbf800ae3c8d01bdf90d9cd8a37e1606ff06 ]

In the function amd_pstate_adjust_perf(), the 'min_perf' variable is set
to 'highest_perf' instead of 'lowest_perf'.

Fixes: 1d215f0319c2 ("cpufreq: amd-pstate: Add fast switch function for AMD P-State")
Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reviewed-by: Perry Yuan <Perry.Yuan@amd.com>
Signed-off-by: Tor Vic <torvic9@mailbox.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Cc: 6.1+ <stable@vger.kernel.org> # 6.1+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 1791d37fbc53c..07f3419954396 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -570,7 +570,7 @@ static void amd_pstate_adjust_perf(unsigned int cpu,
 	if (target_perf < capacity)
 		des_perf = DIV_ROUND_UP(cap_perf * target_perf, capacity);
 
-	min_perf = READ_ONCE(cpudata->highest_perf);
+	min_perf = READ_ONCE(cpudata->lowest_perf);
 	if (_min_perf < capacity)
 		min_perf = DIV_ROUND_UP(cap_perf * _min_perf, capacity);
 
-- 
2.43.0



