Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FBF8C11
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54CFC433D2
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677778006;
	bh=Wc6+4WXmOEo8t6/KAvbIgNO3nCsai+TZxcWiFh9sr/c=;
	h=From:Subject:Date:To:From;
	b=II1w9B2LTb/8fW8Adqvopmj75aDJu8J24KXIYnBnrFfC+bea1SKqOIGXO9ZkjIQQC
	 MKOusEaxjiErGQ8w8vyGTk2AZVsXmjZhBYvLWgfNjwbYQ9OxJ+LcWNu598ENQKDbnz
	 b32JX9GrE7KzSNs1nrURuth8NQa9KhwlCCxiMqhw=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: [PATCH v12 0/3] Completely fake series, edited
Date: Thu, 02 Mar 2023 12:26:31 -0500
Message-Id: <20220825-test-endpoint-send-2-v12-0-9eb08a678d67@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAEfcAGQC/43UzW6jMBAH8FeJONeRP7DH3lOklfoAvUY9+GNIX
 FETAUGNqr57h6xWu9KWrk+AZf/898Dw3kw4ZpyaH7v3ZsQlT3ko9CDkw66JZ19OyHKigUZyKbm
 Vms04zQxLugy5zGyiOyZZdFJ1GAVPPDS0NPgJWRh9iWdaXK59T4PnPM3DeLvvtQi6HP+jLoJxh
 qAkhuh9a/2hz+X61g3XkvxMSffDeGqeiV5kDSeJU4lzLQWoVovD6dXnfh+H11+IqkEUIT5FH41
 I2kn4MtPDroYxqJSGZJyLaftobU2qdj0ax04b1UXZum1O13CaONeCQh0tdOKbwpsazhBnHaCHJ
 E2wsM1BDQfExeB88iEGm7ptzv7hHAehuJKwF8qBBtayl4sveToEf+tzGPH+Ifx+c/9MF19Ov+/
 iakI7Ch2s5dKBo6qa7dCCV/UGX8EYPDhnTQf6G7Cu2dZuEwHXzgjgPP+7PT4+CLqM2OW3+9/i2
 Dw9/lyLVXBOuNCETx612/BLBAAA
To: patches@lists.linux.dev
X-Mailer: b4 0.13-dev-14a61
X-Developer-Signature: v=1; a=openpgp-sha256; l=2342;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=Wc6+4WXmOEo8t6/KAvbIgNO3nCsai+TZxcWiFh9sr/c=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGFIY7oRt+r3K/2pthNLXy0a31rk0JArfOTD5aIPj/uURZ
 8rkeS6/6ChlYRDjYpAVU2Qp2xe7KajwoYdceo8pzBxWJpAhDFycAjARO0VGhtNWHMt99M7b7Hry
 hElLNuxtzZapu661v+p4F/7t/f4v9c4M/0NemTa4C4hOjrJxnbi8+9mSopoDpy82rN4z6YPRri8
 yvBwA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

Another completely fake series to test b4 endpoint sending. Please
ignore it -- it's a random set of patches that exists elsewhere. If you
got this message, it means I screwed something up. :)

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
---
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

