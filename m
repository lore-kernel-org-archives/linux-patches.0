Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1651C13;
	Thu, 27 Oct 2022 19:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB6CC433D6;
	Thu, 27 Oct 2022 19:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666900376;
	bh=35cFf88kblVuwSgahftZiRQRYQbkqp7M3ibAvifLwnQ=;
	h=From:To:Cc:Subject:Date:From;
	b=cVO/GHMPGprH3caldUb141wNEv7znCzlhkzwQLKHBqih2wnXFR+D+D4eKDbHATdLz
	 dmzTEtzhKzDBiwuSVaqPaLx4W3HZDODH1ekvGQww03b4+ZekZP8rwtzymg44UuGrbk
	 k9BmDtzXMNTrFDsSC6MRQMCITRguw3Syjmr41rSesBwO+pmfRHjasHfZ6stfA3gXvT
	 6HSyNo+uWu692nnxZbv2iD4nCJ5cEKdADcZP7sVyh8ydAnvLdOonHcztKU7HGfoziK
	 AUxnGf/++G+ioNTD1on1w7LF0ddmyYdoJNLlpOMAHGizjtEGmS3nOUkS8gBnM0S8Ji
	 HOhhsfsmrbYzg==
From: Nathan Chancellor <nathan@kernel.org>
To: Jean Delvare <jdelvare@suse.com>,
	Guenter Roeck <linux@roeck-us.net>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Quan Nguyen <quan@os.amperecomputing.com>,
	linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH -next] hwmon: (smpro-hwmon) Add missing break in smpro_is_visible()
Date: Thu, 27 Oct 2022 12:52:38 -0700
Message-Id: <20221027195238.1789586-1-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang warns:

  drivers/hwmon/smpro-hwmon.c:378:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
          default:
          ^
  drivers/hwmon/smpro-hwmon.c:378:2: note: insert 'break;' to avoid fall-through
          default:
          ^
          break;
  1 error generated.

Clang is a little more pedantic than GCC, which does not warn when
falling through to a case that is just break or return. Clang's version
is more in line with the kernel's own stance in deprecated.rst, which
states that all switch/case blocks must end in either break,
fallthrough, continue, goto, or return. Add the missing break to silence
the warning.

Fixes: a87456864cbb ("hwmon: Add Ampere's Altra smpro-hwmon driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/1751
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/hwmon/smpro-hwmon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/smpro-hwmon.c b/drivers/hwmon/smpro-hwmon.c
index ee54e21c2c12..667e88b6bae5 100644
--- a/drivers/hwmon/smpro-hwmon.c
+++ b/drivers/hwmon/smpro-hwmon.c
@@ -375,6 +375,7 @@ static umode_t smpro_is_visible(const void *data, enum hwmon_sensor_types type,
 				return 0;
 		break;
 		}
+		break;
 	default:
 		break;
 	}

base-commit: 0ffb687b6508c36a17b99bdaf014b38532404182
-- 
2.38.1

