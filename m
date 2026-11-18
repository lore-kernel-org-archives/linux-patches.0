Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060452;
	b=pTIaxYGAMZ7ng/IbTghhPUyQsTOGqhOgv6aFZaM4gEW5t848I6zcqH5I20UNlm2kraXm
	 tJDs9rIPHVAsFWJ2/yZEM5p6ITCdISMynxazzVro9ybXPP0qlgG2a+vyDg3relUAkm4XC
	 Qa+ut7bUu/HCkk7VYxRoTTGzqtoTgS7XphnN6301t3wkAkooKasOjoYGhaycsZpUL47X/
	 PAmovRq3xTMGKEjRwB56fwRKshskC2S18vuCqXE2YCx6/MWuEhKajPpkTays6qvJJUe+T
	 P8onUAd6EZJpQv80qtGzaLJlL+n5V7YbWIK2JpUivdcM76xwtM7mCyTw5Ml3LB0kRYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=92BkXAiaezx4wseehsVMgbszZuaV3huVsampRCw+Dqg=;
	b=43VB8eeFZwcfmYfc07mc9r5MlvIveJ3Zi7/wgUlKSsZEkPXDHxlSVcu9ikExmu3gTpfZ
	 Mj8KAu/bSffg/zwrCohijToOANq+sa7quukvO45uP7XAYvXN+/FjI/4vULRkQiZNm477G
	 0gZFTVOzlz/pKFdKVHfaAD8F/2vhjGnsthJRvRnP6GJi/iaG8iLJqwNMX7D5C28khpeP8
	 0d07Zc210cwH0ND3aSFVphR0Ij6JGeFcfoSI/msbY1Nw37UgmRygG08I/GnAKpO1uI0wm
	 C2h9uBjEuQ5SvR1V0lbEo0cv0t5K0aerHZ+F0zHppaUkOj+8ec5r8ol5D7B2I6q1ppg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJj45XyM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61098606A320;
	Thu, 19 Nov 2026 03:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJj45XyM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB0D1F000C4;
	Thu, 19 Nov 2026 03:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060452;
	bh=92BkXAiaezx4wseehsVMgbszZuaV3huVsampRCw+Dqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJj45XyMCC1UdeD/ZgT7L7r2WRceGGnYBQMlE4SQYbVmW6mM1OJbyVXqHB1Jpb1uM
	 hG1OLEmFG+5t6/SSrxc5+t4Jhnsj14PnXSArdzZAB/RcKDbb46cH6yitIaxZVhJFH3
	 DjE5QVA1acpfrcfJIvw9XhApwh3lJD9huvVY9ngk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1205/1848] efi/libstub: Fix efi_set_event_at() parameter documentation
Date: Wed, 18 Nov 2026 15:54:03 +0100
Message-ID: <20261118150010.462928132@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit c12a3a4b35e47fd511fbd550d3637318be41c4eb ]

efi_set_event_at() documents ids although its array index argument is
named idx. This produces missing and excess parameter warnings.

Match the argument name and fix the adjacent spelling of array.

Fixes: 8c0a839c2bcc ("efi/libstub: Descriptions for stub helper functions")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efistub.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index c5e0c6e99d20c..40a954033ef2a 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -181,8 +181,8 @@ typedef void (__efiapi *efi_event_notify_t)(efi_event_t, void *);
  * efi_set_event_at() - add event to events array
  *
  * @events:	array of UEFI events
- * @ids:	index where to put the event in the array
- * @event:	event to add to the aray
+ * @idx:	index where to put the event in the array
+ * @event:	event to add to the array
  *
  * boottime->wait_for_event() takes an array of events as input.
  * Provide a helper to set it up correctly for mixed mode.
-- 
2.53.0



