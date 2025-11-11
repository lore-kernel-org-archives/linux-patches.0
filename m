Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C343126B9;
	Tue, 11 Nov 2025 01:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824914; cv=none; b=tb/TqjPKpGf213wg5Sy6S+9zWEquP//Og8GBbSflNzDy5375GpcgUd3Zo7BmKB/OOVS2eaKmJTOfYbA98W0Fq0+FKGc1n5KdQ9X6O72pT4ydpxxwhudvlZL+HYeNbllZcQKuJV5QJZ0JXYWVFj7j69xamkTnoay8nrPv6kiEx2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824914; c=relaxed/simple;
	bh=i+/YuHzDJ2iA2AG8ZcK3ajTwv9XBMkAWJeZG8HqfXBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lpmm82Rfh5jZzz12eyGf2imrGwkvJ86qmVretnQwI9Bf5pRKeYnKhCg105/vTWHiwieOgSMiw5stvIQQyHrQ9rwVMWuU+Wib75NlehbymluYyqwk6yB3wUB/wONqilWQPWa7E91d8U2Swh8MQjoeI2uir3bLna5Bst6CDInwm2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7HVZhb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7HVZhb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F7AC113D0;
	Tue, 11 Nov 2025 01:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824913;
	bh=i+/YuHzDJ2iA2AG8ZcK3ajTwv9XBMkAWJeZG8HqfXBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7HVZhb7GqaDEu2Jr6a1tuM/ew694cbsYeAPp1WKTgZcBS1B6tLPMdQ5ktm1WvCD3
	 Ge2OUgxP/VibBNi9i1TxM1AQqsQKcz4qZai0B0RHpopo7aAAcQlD6f3XZ49eIvOYPl
	 JWF5zmHD+kyEwB1iFIn9rE3Q/9gcYfLzsxoQ6EW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.12 549/565] x86/microcode/AMD: Add more known models to entry sign checking
Date: Tue, 11 Nov 2025 09:46:45 +0900
Message-ID: <20251111004539.346600069@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit d23550efc6800841b4d1639784afaebdea946ae0 upstream.

Two Zen5 systems are missing from need_sha_check(). Add them.

Fixes: 50cef76d5cb0 ("x86/microcode/AMD: Load only SHA256-checksummed patches")
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20251106182904.4143757-1-superm1@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -208,10 +208,12 @@ static bool need_sha_check(u32 cur_rev)
 	case 0xaa001: return cur_rev <= 0xaa00116; break;
 	case 0xaa002: return cur_rev <= 0xaa00218; break;
 	case 0xb0021: return cur_rev <= 0xb002146; break;
+	case 0xb0081: return cur_rev <= 0xb008111; break;
 	case 0xb1010: return cur_rev <= 0xb101046; break;
 	case 0xb2040: return cur_rev <= 0xb204031; break;
 	case 0xb4040: return cur_rev <= 0xb404031; break;
 	case 0xb6000: return cur_rev <= 0xb600031; break;
+	case 0xb6080: return cur_rev <= 0xb608031; break;
 	case 0xb7000: return cur_rev <= 0xb700031; break;
 	default: break;
 	}


