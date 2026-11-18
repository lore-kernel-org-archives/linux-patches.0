Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058136;
	b=mKfZXepGWL6Fkx+3RH1/GzGafWUC0WP8ktSRpF3Jgrajrhtxx5JPmtG4OHL6uidObonU
	 OGfTDmrlGc7puyXSibGB6w81mBWWoXb+2fDdTSjNk2wJtyXYQC5McUliWSJUQiSZmwhIo
	 7lirr7rnBtsMtYk0xYRl0PDw+jSLZ6Io89x4fWz34MHh9BzZY1+qIAJLpG6epOOwu/Sp8
	 bdP7P+wuHRbfohCdRQqZJXTkaBYi+RYXqXAxIq6rPnIQEzO4Gt6pUB8EGrUpHMB8Ds/NN
	 C3FEr7YWxScDNg792PEu1z9teNUJSTNx0Ow+2FVDKl+yzTpCRrr0KnfkYkaH8lTAiPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UydX5SBe5IFXqA6+KBSDbv3nFXaRqMtGJmc38EY2MlY=;
	b=ZsVSwZhAienqW4r2CAoQRsLVzud1NpRaZePz2/9EuQ2/b7Bhgps0IDvz9+M0OPjJuryL
	 Yxk4q/jpRYTaofEBcJt/2wvbFrN8P5kPkAsdrCFTqHFBi6zUXVFEi0bUjK2RHzyTt7zMr
	 Izmxob5hWnsU1zQ4cIZy3gpKx/Hnpp7ELzUeZc0N+OKLoRX0TWVAJDAUSTeUm80gr7cFd
	 JogWf0aGCoeU9BbIh8fhDLT7/UnS/UbSTTzrqy7qi10J0crimnn50pwX1NDNhsaD97x3h
	 7+Jw2WPHkXrn+f7VYIqSFUhRUspB7wN5jP882wdu+7ZA8p+89SvmHkLWVLCLAEzMWDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6iWq+s9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E976D606A326;
	Thu, 19 Nov 2026 03:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6iWq+s9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCDB1F000C4;
	Thu, 19 Nov 2026 03:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058135;
	bh=UydX5SBe5IFXqA6+KBSDbv3nFXaRqMtGJmc38EY2MlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6iWq+s9sATSwfmWxUrSx1yEIA67z67Ohv5F6yCU14LRdJlkl1nc1JR34izyYEGTq
	 VZkoxTDRHuJGeo5YIlTMsSN1U4GCq3ZYcOfqnUzTIUNAk1wBaR6Fw0JzrWhgLYnrP5
	 GSocB3LbUm2MAH9RJ4+3Dgm6VGR4SSZCRj/kc5m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0378/1848] media: adv7604: avoid negative array index in log_status when cp_read fails
Date: Wed, 18 Nov 2026 15:40:16 +0100
Message-ID: <20261118145929.318653770@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 10d8dfda1c08f6788049aa100685e223d857f901 ]

cp_read() returns the negative errno from regmap_read() on I2C failure.
adv76xx_log_status() shifts the result right by 4 and uses it directly
to index csc_coeff_sel_rb[16] causing the right shift of a negative
number to result in -1, reading a negative place in the array.

Commit 8163419e3e05 ("media: adv7842: Avoid possible out-of-bounds
array accesses in adv7842_cp_log_status()") fixed the identical pattern
in the adv7842, so do the same thing here.

Fixes: 54450f591c99 ("[media] adv7604: driver for the Analog Devices ADV7604 video decoder")
Cc: stable@kernel.org
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7604.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 9eeb7a4d1f80f..a17de66c83f38 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2605,8 +2605,9 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
 					"(16-235)" : "(0-255)",
 				(reg_io_0x02 & 0x08) ? "enabled" : "disabled");
 	}
+	ret = cp_read(sd, info->cp_csc) >> 4;
 	v4l2_info(sd, "Color space conversion: %s\n",
-			csc_coeff_sel_rb[cp_read(sd, info->cp_csc) >> 4]);
+			ret < 0 ? "" : csc_coeff_sel_rb[ret]);
 
 	if (!is_digital_input(sd))
 		return 0;
-- 
2.53.0



