Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E7B8F40
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10224C433EF
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677778832;
	bh=IH2FomsuErgif8VxVplNfHhj2KKyd1Yx2vzH8yBA4NY=;
	h=From:Subject:Date:To:From;
	b=Rc1eM/7a6UXrvSjXPZfGjTFG9TPdyvtg+CP1QWHxZ2kTQk7dmVw0r4DC5T9OXTxK+
	 LZJqlWYBJTws0cI7bLQ700c3M/25oro2E5As076DBoGd839Yd/MBYts9OmLOxVEPX8
	 WbhfBRPDbsaHbj3BoLeDBR9VwZtkcqhoPmX7j53o=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: [PATCH v13 0/3] Completely fake series, edited
Date: Thu, 02 Mar 2023 12:40:17 -0500
Message-Id: <20220825-test-endpoint-send-2-v13-0-047ec9929bec@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAIHfAGQC/43Uy27jIBQG4FeJvC4RF8OBWUUaqQ/QbdQFl+OEy
 sWR7ViNqr57jzMajTRTd1gZI/g4gH+/NxOOGafmx+69GXHJUx4KvQj1sGvi2ZcTspyoo5FcSm6
 lZjNOM8OSLkMuM5uoxSSLTqoOo+CJh4amBj8hC6Mv8UyTy7XvqfOcp3kYb/e1FkGP43/URTDOE
 JTEEL1vrT/0uVzfuuFakp+p0v0wnppnohdZw0niVOJcSwGq1eJwevW538fh9ReiahBFiE/RRyO
 SdhK+rOlhV8MYVEpDMs7FtL21tqaqdt0ax04b1UXZum1O13CaONeCQh0tdOKbgzc1nCHOOkAPS
 ZpgYZuDGg6Ii8H55EMMNnXbnP3DOQ5CcSVhL5QDDaxlLxdf8nQI/tbnMOL9Q/h9c/8MF18Ov6/
 iaop2VHSwlksHjk7VbBcteFU2+ArG4ME5azrQ34B1YVvTJgKuyQjgPP87HqIqZGJNmcPArTdgk
 9m47I8PIi8jdvnt/vs5Nk+PP9fTLzgnXGjAJ4THNxOcBAAA
To: patches@lists.linux.dev
X-Mailer: b4 0.13-dev-14a61
X-Developer-Signature: v=1; a=openpgp-sha256; l=2502;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=IH2FomsuErgif8VxVplNfHhj2KKyd1Yx2vzH8yBA4NY=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGFIY7vdzLZ6u0CRgbcsUxBeoVX/Qbefvz8ULTzrvWHhcp
 XyG7S2VjlIWBjEuBlkxRZayfbGbggofesil95jCzGFlAhnCwMUpABMxP8LwV6ju4XdjEcf1G3xb
 Ns25qSAW+Lpoo3FRlfL+sKQna5oSJjP84Q1QiHAQuyMplKhicvH23Ylm63+eZd9rPkNf7vd1/f+
 qjAA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

Another completely fake series to test b4 endpoint sending. Please
ignore it -- it's a random set of patches that exists elsewhere. If you
got this message, it means I screwed something up. :)

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
---
Changes in v13:
- No changes, just increment
- Link to v12: https://lore.kernel.org/r/20220825-test-endpoint-send-2-v12-0-9eb08a678d67@linuxfoundation.org

Changes in v12:
- Changes to Cc trailers in individual patches
- Link to v11: https://lore.kernel.org/r/20220825-test-endpoint-send-2-v11-0-1be3451b79a0@gmail.com

Changes in v11:
- Change commit author for testing reasons
- Link to v10: https://lore.kernel.org/r/20220825-test-endpoint-send-2-v10-0-bcba79986f75@linuxfoundation.org

Changes in v10:
- No changes, just junk.
- Link to v9: https://lore.kernel.org/r/20220825-test-endpoint-send-2-v9-0-b88029795c86@linuxfoundation.org

Changes in v9:
- No changes, just junk.
- Link to v8: https://lore.kernel.org/r/20220907130327.139757-1-jpanis@baylibre.com

Changes in v8:
- No changes, just junk.
- Link to v7: https://lore.kernel.org/r/20220825-test-endpoint-send-2-v7-0-cb9adabcb8df@linuxfoundation.org

Changes in v7:
- No changes, just junk
- Link to v6: https://lore.kernel.org/r/20220825-test-endpoint-send-2-v6-0-897ea7d26b87@linuxfoundation.org

Changes in v6:
- No changes, just junk.
- Link to v5: https://lore.kernel.org/r/20220825-test-endpoint-send-2-v5-0-9473e5c87f1a@linuxfoundation.org

Changes in v5:
- No changes, just junk.
- Link to v4: https://lore.kernel.org/r/20220825-test-endpoint-send-2-v4-0-30ef563fc249@linuxfoundation.org

Changes in v4:
- Rebased on v6.0-rc3
- Link to v3: https://lore.kernel.org/r/20220825-test-endpoint-send-2-v3-0-6e3357d699cd@linuxfoundation.org

Changes in v2:
- No changes
- Link to v1: https://lore.kernel.org/r/20220825-test-endpoint-send-2-v1-0-e732ebcaa48a@linuxfoundation.org

---
Clément Péron (1):
      arm64: defconfig: Enable devfreq cooling device

Konstantin Ryabitsev (1):
      Another commit

Konstantin Ryàbitsev (1):
      Junk babootich

 Makefile                     | 2 +-
 README                       | 2 ++
 arch/arm64/configs/defconfig | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)
---
base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
change-id: 20220825-test-endpoint-send-2-c923fec10d0b

Best regards,
-- 
Konstantin Ryabitsev <konstantin@linuxfoundation.org>

