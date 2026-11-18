Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062263;
	b=shKsWcvMnxk/sDqZ5L86n5vHITphdgQ4jykiS1mWqSLd8vzSW1VHUdXfAaUWzr+XCyEK
	 xJ54++siBu0vCztDlAP9wo6IyG81rFjz0KXENCnjNsWYqJCdXsS0EzH67S9WUENsXOyGU
	 yDkcEb+Iz5Pt8wabjyp0zCnYmGiP4JB/e/r69Jdp8OXIHAjvMURQQOMI8dHR6SIynqUWy
	 ImAO96wmjLwfB1OI9ADe+VtHV9Ck8eIOLVcONY8JH0QATPydqooqjpUERdL4J9HjDmzwp
	 3+sZpLN4NAS7nhsYWsGExo3hqU7FaVN4DyGIKt9gAW5nfePMoGI6oOSRxN6iUbHeaag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jyO/5/Hs3G8+Kvf++BOnVim9h7wOalB4yc7/IbHLGpQ=;
	b=gRQI7Klo2cwlswtn70jOWAcnBhD07IUkyklWYiWHc2QudckwHQra/Rp/wUxIDV7bqqCd
	 E+JQSX5gOjvdRBt2MO6KkVip6mbmSnQ+8JLILR5ZK86R2Ul8k8YNAWMFu6wGK2D96CseS
	 vS77ByxlEPido9Br9kmzEyCYH+NKZP9xeBsz5+RrKugfxNVjHMfuqsoEHBS689I5s7JmH
	 YJhmEdQQGbJZxgLNrBALHdF/KJc28L5CM2pJA51CNaZLVnV2zoQlarD6xJs+H2WAFu64c
	 33Y/JbrEAuxMWjfN5mVrS24E81/YwzGJM97hzfwOdT2crLC4n4qyf31hqmLID8mN+/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zws69udM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA0E606A320;
	Thu, 19 Nov 2026 04:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zws69udM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DDF1F000C4;
	Thu, 19 Nov 2026 04:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062263;
	bh=jyO/5/Hs3G8+Kvf++BOnVim9h7wOalB4yc7/IbHLGpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zws69udM3JQTBKIQ4brbmbZuZ0hyqXnX0u2x6/IckenYq0d7ytU3TEGaV5j7329tN
	 oNuuKCEed7nbG4TDOZRSrpN7kkivguR3fK+ogmW/3MVZ9fAp+di9KlhG4R37czSPCj
	 h7iyskeCXb7OGUYm1aVu6GtqAinwo/daPK3yPvK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 1847/1848] time/kunit: Use correct format specifier
Date: Wed, 18 Nov 2026 16:04:45 +0100
Message-ID: <20261118150036.861072162@linuxfoundation.org>
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

From: David Gow <davidgow@google.com>

commit e0a1284b293bdf91a68a6d1a0479ad476d0d8ec2 upstream.

'days' is a s64 (from div_s64), and so should use a %lld specifier.

This was found by extending KUnit's assertion macros to use gcc's
__printf attribute.

Fixes: 276010551664 ("time: Improve performance of time64_to_tm()")
Signed-off-by: David Gow <davidgow@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240221092728.1281499-5-davidgow@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/time_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/time_test.c
+++ b/kernel/time/time_test.c
@@ -73,7 +73,7 @@ static void time64_to_tm_test_date_range
 
 		days = div_s64(secs, 86400);
 
-		#define FAIL_MSG "%05ld/%02d/%02d (%2d) : %ld", \
+		#define FAIL_MSG "%05ld/%02d/%02d (%2d) : %lld", \
 			year, month, mdday, yday, days
 
 		KUNIT_ASSERT_EQ_MSG(test, year - 1900, result.tm_year, FAIL_MSG);


