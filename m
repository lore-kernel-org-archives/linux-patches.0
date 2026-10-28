Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212746;
	b=fokQpZoU7ES2ZNo0oTktwPkJRJcFELEw2hrcU+NLuh+DHGFw8nYvOdKdtKGl0et5o6HJ
	 +21EAuBZ9L2hEOSu8H6K5wQqtpDRRhh/rS/YrYovIW+ZUYqxOGnCRfgQMru+5BDqZmezR
	 vGZ9R11Eb8j7zfZQB2ZkGXdZfH7eEDTdnEYv82L6390x1lyxrU7qBLoJok2Md0q9Vtu+c
	 eneviYUC4Fo2j4QvACNGDhhSm9bHLXdkM5Xh9wmCQzxViyyK4l+Wqgpe8qpCh32gZ4qYs
	 i1qQcTfK/fFC1XCorvJnu6aZFUlzrTkiRc9J8PqBajhbi5fv9u+mZLsxe4yQ/lh8nDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jsTyLKijjz2MHxVtR8cZGQbRQfrOXwB6xSrmAqA4Bvo=;
	b=rUnXsUnNWq3qxlxso220KH2vaLQhhsfgqurWcARF7mL70PZftnX4KrDVUJrB6n62owcQ
	 Q/RPNBMdollKg/B7doL4+7cMYdiKwokpLIhyeyhuMngjJ4os6cM0Ju2SAkug4luh5Lhrt
	 UgCFqHFoVldcHrv5i7g63G797F9BRv1bYvW7IykbgcEffwt683KcZhTh8eZ4lwd6j2gYj
	 pn/Z8YPFdxFeNZyefFzNMFE2ETOIffVPhSVb1079aheqbykGYh5ZYsz9fyAOQYqLcFNMM
	 Q7Iiocg7z9DOjyQEqO4ZyoCjyIPPXUseya5pbZvCQpiHfTxnem1ACDA9piyQc+vok/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rMKtBDFd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F41B606A32C;
	Wed, 28 Oct 2026 18:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rMKtBDFd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03771F01825;
	Wed, 28 Oct 2026 18:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212746;
	bh=jsTyLKijjz2MHxVtR8cZGQbRQfrOXwB6xSrmAqA4Bvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMKtBDFdIoK6d9CaPi90tlOMJ0T8CEcMbUJJGcbH9IUm0/AtXtaYHffF6m6lFCMop
	 4S3md0Mg2QX/iGIn2AphjxVePn0u/f/3Jb9eDHUtgv4US3q3sLeOK4QXwgw6AkAAUX
	 nYVa/wT8DgkWTXpp/G0FFsmqDLCvJF/zS6/YE518=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Rosencutter <rosencutter@gmail.com>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0263/1887] Input: synaptics - add LEN205b entry to smbus_pnp_ids for ThinkPad T490
Date: Wed, 28 Oct 2026 17:39:19 +0100
Message-ID: <20261028170505.215248850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>

commit a961417c5ae77bbb728a23d9577ecd8f4d8a4b5a upstream.

Lenovo ThinkPad T490 has a Synaptics Touchpad that supports SMBus/RMI4
mode, but is not listed in smbus_pnp_ids table.

Add LEN205b to smbus_pnp_ids[] passlist.

Reported-by: John Rosencutter <rosencutter@gmail.com>
Closes: https://lore.kernel.org/all/CAOGuaRh025eKcBf9P8UrvtXNp68vQ0HVF2EbNMp-kpdaC1HNpA@mail.gmail.com/
Signed-off-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Link: https://patch.msgid.link/20260920200730.1836756-1-lovekeshsolanki00@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -190,6 +190,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"LEN2058", /* E490 */
+	"LEN205b", /* T490 */
 	"LEN2068", /* T14 Gen 1 */
 	"SYN1221", /* TUXEDO InfinityBook Pro 14 v5 */
 	"SYN3003", /* HP EliteBook 850 G1 */


