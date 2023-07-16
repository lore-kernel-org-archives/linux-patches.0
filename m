Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9478F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6A1C433C8;
	Sun, 16 Jul 2023 20:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537936;
	bh=xg7FdGgVeH2L7lcNu9O/62PQ5D/txcCZrPj4g/Koj18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buGrC0QUSDkR1GzkoGTRSp9Yo/L84Qvp+EG0OSXgwJwFOKaoATWuVW9QW6z2HM6IX
	 aOy5YrjqmH3F/E2eLr+MuGX53y4Phky9C/oYY7TDeCyYEm95ACGveHE0hYU2McJdAj
	 hBLUw7SIc1FD+NkLBAsgQM4uE7P8oAqmZQ0TDs2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 244/800] Input: tests - fix input_test_match_device_id test
Date: Sun, 16 Jul 2023 21:41:37 +0200
Message-ID: <20230716194954.769029259@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit c73b4db076faf827d0656665ef5e97b76926b60f ]

Properly initialize input_device_id structure in
input_test_match_device_id test to make sure it contains no garbage
causing the test to randomly fail.

Fixes: fdefcbdd6f36 ("Input: Add KUnit tests for some of the input core helper functions")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/ZFLI7T2qZTGJ1UUK@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/tests/input_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/tests/input_test.c b/drivers/input/tests/input_test.c
index 8b8ac3412a70d..0540225f02886 100644
--- a/drivers/input/tests/input_test.c
+++ b/drivers/input/tests/input_test.c
@@ -87,7 +87,7 @@ static void input_test_timestamp(struct kunit *test)
 static void input_test_match_device_id(struct kunit *test)
 {
 	struct input_dev *input_dev = test->priv;
-	struct input_device_id id;
+	struct input_device_id id = { 0 };
 
 	/*
 	 * Must match when the input device bus, vendor, product, version
-- 
2.39.2



