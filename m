Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029422;
	b=V1sRJq7bzxV1oJ00bVrBI8kuCjvJHYKqBpXovbV/WtmObK6CAOPTwUvkWmHs3pu7cBh9
	 KblFOJNVZl4sHIxiefNCR/Kjb43QYEAjLpnHzyyRzrd9rTfsuZjeQAaWmgqzUsSl833Zc
	 4YpVnlVWzODlPIIlHd547p2W6hgWcjEPhWCGxTfuL1hZ5OP6qMtCumDWVxB3f7KrmogYk
	 QNRCUH7Vssr/es1VIaMJHGLIQ/0m5OC9QjfAq2cMHQ1yx1Nsr71mNv7jegBsPA64zZSX2
	 NTvG4sj11WtXbQVbP0hd6FDgvUvK5AXqSSbqNqylZ4OxijoCNn9MnKlvs8T6EkXHAQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6WsXvfLmgZ4LmC6JT0pn5CD8+oKCiqmBh+JRES9l6Xw=;
	b=JpGG1EE+5kez1O4SFjksFWhIfMuNWobwzYTSyX8tTqNWD/jTxanbD0qdTzPzQMPQRQNe
	 b1ekPusozkV8XYksQRnWjn9mAsW+5m+9ebsO9nVW6oHOcdcSpVoIRmR5prPlvDwnQWcuz
	 8iMmjcklnx4KdelKo+wIWEAeF1qidCGS0IsTyHkaOCWAoJno5Fnnt0HhGCyihv58TDcwG
	 C6Kw+B8b5G+xE7yOiZHOTnbOKQVQpBv1ZkCx6rr7jmO/q55uZjai4WfFFWJMafgOnxUpF
	 HMj0qPiU2E/0/K6+r/i1rzFdRj5gZxUVM45x+RD6W5vgYVPXrbzLLIbORknGb/sNRZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SI0d+9Me;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47EC606A32A;
	Wed, 18 Nov 2026 19:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SI0d+9Me
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FE81F000C8;
	Wed, 18 Nov 2026 19:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029421;
	bh=6WsXvfLmgZ4LmC6JT0pn5CD8+oKCiqmBh+JRES9l6Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SI0d+9Me+UEqrp9R8zwt8cu7w1S5avwRIqpy8am10fwklggmyCNwGnl17z7ODpTkW
	 pp/BEYUJTUC9cwH+1o1Y0mCWeuz/ZxwHWortZ4HE84C87oamHBP1gytDZ9DtiiI5xp
	 H1cHfehJRxNeR4NfhtMg9E6xAuEC57BPvEr5pPGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0344/1756] regulator: ab8500: Remove stale expand_register kernel-doc entry
Date: Wed, 18 Nov 2026 15:41:11 +0100
Message-ID: <20261118150022.057515169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Babanpreet Singh <bbnpreetsingh@gmail.com>

[ Upstream commit 0991f3b4624ed713d1d5eb56520c1c9b2deaab7a ]

Commit aeee55b76bfd ("regulator: ab8500: Remove unused embedded struct
expand_register") deleted the expand_register member from struct
ab8500_regulator_info and, in the same hunk, added an empty
"@expand_register:" line to the kernel-doc block. That traded one W=1
warning for another:

  drivers/regulator/ab8500.c:196 Excess struct member 'expand_register'
  description in 'ab8500_regulator_info'

Drop the leftover line; the remaining @member entries all match the
struct.

No functional changes.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202605160857.ZIE3nO9J-lkp@intel.com/
Assisted-by: Claude:claude-opus-5 [kernel-doc]
Signed-off-by: Babanpreet Singh <bbnpreetsingh@gmail.com>
Link: https://patch.msgid.link/20260802013304.7-1-bbnpreetsingh@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: ac72c091a981 ("regulator: ab8500: Add AB8505 VAUX3 3.05 V setting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ab8500.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 26accd604c395..ca59406d42a85 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -173,7 +173,6 @@ struct ab8500_shared_mode {
  * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
- * @expand_register: 
  */
 struct ab8500_regulator_info {
 	struct device		*dev;
-- 
2.53.0



