Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144872036FA;
	Mon, 23 Jun 2025 21:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715883; cv=none; b=JJxSlfz94xqFvsUBWwLKjya7v4UIW8eKbJx0W/VNN3wbAu7kMLCK2YiciQPzIUvy4nppnnPVbRyd54/2AXEpH03rJNTvjzltCLhmvw7LP8iopLxFwdHmKoHn35S8trfEU0gIDKObdEjp2ivAWNj+VbFrE/KB0tCHKNQ/eNQyVNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715883; c=relaxed/simple;
	bh=sXWlVLyZwJYbUuv1BUVxEfE+SBnVxd8pAlBhBNrJFho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5Fx+4P0PzVkRjgL9kp60nTuUWItabUr1PgwfP+TF6540soc8nBD+Vj/W0xnUXPkEzDGA0tUxmmRI2+7G3pkmv48GE94u/s0TKCQanfWmkRjysuDtwuyxqFSm/kKhEWwV4HWAyBc7KqtscaKD6yOD5mESvj4V3nODUG59p+e8aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLo2MI2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLo2MI2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CF1C4CEEA;
	Mon, 23 Jun 2025 21:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715882;
	bh=sXWlVLyZwJYbUuv1BUVxEfE+SBnVxd8pAlBhBNrJFho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLo2MI2Gt5YuzDh60OBArhdVIfL+UKYAsTeFkNakqBKjFs9OgnkOvLad6Glz4R8MF
	 rjFtemfhqKyh59B38ZHio6WuuZoFh4WlTKO0LSjD7xrU0B4IvAKD3MEL42j3VavXkN
	 X/jcGMhDF6DwEzt/B3bzi0VWkwWWA+WwUw4cSmn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Bauer <sbauer@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.10 328/355] arm64: errata: Add KRYO 2XX/3XX/4XX silver cores to Spectre BHB safe list
Date: Mon, 23 Jun 2025 15:08:49 +0200
Message-ID: <20250623130636.610640363@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 0c9fc6e652cd5aed48c5f700c32b7642bea7f453 ]

Qualcomm has confirmed that, much like Cortex A53 and A55, KRYO
2XX/3XX/4XX silver cores are unaffected by Spectre BHB. Add them to
the safe list.

Fixes: 558c303c9734 ("arm64: Mitigate spectre style branch history side channels")
Cc: stable@vger.kernel.org
Cc: Scott Bauer <sbauer@quicinc.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Trilok Soni <quic_tsoni@quicinc.com>
Link: https://lore.kernel.org/r/20250107120555.v4.3.Iab8dbfb5c9b1e143e7a29f410bce5f9525a0ba32@changeid
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/proton-pack.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -862,6 +862,9 @@ static bool is_spectre_bhb_safe(int scop
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A510),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A520),
 		MIDR_ALL_VERSIONS(MIDR_BRAHMA_B53),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_2XX_SILVER),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_3XX_SILVER),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_SILVER),
 		{},
 	};
 	static bool all_safe = true;


