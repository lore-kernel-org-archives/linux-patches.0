Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF1A2528FA;
	Thu, 17 Apr 2025 18:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914526; cv=none; b=BiIS0m7jpTQ+AR9TgpzU+KnlJazsikFuX9bcrqeiQnSMxrGvkRthESKQdndJiNZAu+WNng9e1iTmYfDOoxbwt1FiW4dqfA9U7BBztRkVK2F4Ew2JPE6zXzXRwNpNsG/RqWcDduxj84aVcY4/dpobjZUcX7Qu/el+pUOCs4CK/kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914526; c=relaxed/simple;
	bh=+TJWSL8dkfpvYhgWDuYpxPZV/1dkz/TNNWfDsfLvpYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yji+FrG1x2bkYyRZ4aghHp2iD//FJuOY25pzEhaXNj5rKVVqt/hN0+LkKK9O0gQCc8rqPuXM2dTi3B52BnZcxwsGu7lbOfkk0C6fy4fjltGUnRrrh7sCyA/131+/NMthr0GyFHuQ5TEy3xZJ4aw70J2EXbgY2CiCIyclq5niQjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E47gmyHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E47gmyHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE31C4CEE4;
	Thu, 17 Apr 2025 18:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914526;
	bh=+TJWSL8dkfpvYhgWDuYpxPZV/1dkz/TNNWfDsfLvpYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E47gmyHmnddtJ8NjySvk05VEHTeGEpiuY+htg4++bp3rUBMYT/fcEpqz8RdseUURg
	 CCNkj04uh95c3Mu3Fzm1RJvAoaDxSu9XUEXBdOwsq5zOf4ox2ZyYr1lCBU85WMMfG3
	 dW4Am8CTGBbd535L91ijk21jgDWVBZvvuC13AJYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Bauer <sbauer@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.13 214/414] arm64: errata: Add KRYO 2XX/3XX/4XX silver cores to Spectre BHB safe list
Date: Thu, 17 Apr 2025 19:49:32 +0200
Message-ID: <20250417175120.045458726@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

commit 0c9fc6e652cd5aed48c5f700c32b7642bea7f453 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/proton-pack.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -854,6 +854,9 @@ static bool is_spectre_bhb_safe(int scop
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A510),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A520),
 		MIDR_ALL_VERSIONS(MIDR_BRAHMA_B53),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_2XX_SILVER),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_3XX_SILVER),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_SILVER),
 		{},
 	};
 	static bool all_safe = true;


