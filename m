Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478CB149C53;
	Wed, 28 Aug 2024 18:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724868353; cv=none; b=F2ILbprzzvr7tqILsIYtexeY6ZqaF4iL3ou1e7ydTN43UYFa9S1jUwsLgr6tQRA/mYNwsVZ5v3cAAh+wbiZysO0+RGLE4FKn2loANtIPR+sGbJUfC94pT0wvrFNDHbOOnS1UdtK9Qvur3MwC50A2Ewyd7n1/J4FGn3e6bI3oZYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724868353; c=relaxed/simple;
	bh=xfR7DLMbJuXnyQugqbUW1ndOSxrOfW6eObhJ/3J9Tf4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=JSre+UNkpK55d2yvny5GcSy279SN29t9TO6Lh9NIZp6VsQRIR/D6vJ5ciT6ii5RZJJWoprPIXADqnbtBg2DLzovG15xx+Gt3UoiiabwzcK55tHiQSjXf0U/FRmeV74/0VCrorVwerpR30ebK/TJ+UUFarm6k/pZdt0jl73GiduM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Il4mO7Aq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Il4mO7Aq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB74C4CEC0;
	Wed, 28 Aug 2024 18:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724868352;
	bh=xfR7DLMbJuXnyQugqbUW1ndOSxrOfW6eObhJ/3J9Tf4=;
	h=From:Date:Subject:To:Cc:From;
	b=Il4mO7Aq6kJcNROSA+XPb/nws7e9lSOvF2Q4Q3uGvh/0vWMeUXEDr9rgcecqoYZcA
	 fEyN8Wm4C//Y0crvL5hXNT/r3aYFO4hhUYh8Su89hmj4GRcSMDkCYTH1JUI/8DTnmj
	 oaZB2M6fkyDJ5BGnpLruw9fzGwGL6AIk5CkOxy2a5X0AvfAEJXGrrFgcSxugFBmR0L
	 nJULbqDs10u/van+b45VKAOZTwRvN9nJ2NgYGI4GjY/zsiwhhSOaWjwN6DJ6D13xgI
	 CNzvguFg4mj6S5+veCMHhmeK/PSsheoXP2xSxtz+3QSm2Zjnq9JjUxMZELFt32D65e
	 Z9w3BY9dz2FPw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 28 Aug 2024 11:05:35 -0700
Subject: [PATCH] hwmon: (oxp-sensors) Add missing breaks to fix
 -Wimplicit-fallthrough with clang
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240828-hwmon-oxp-sensors-fix-clang-implicit-fallthrough-v1-1-dc48496ac67a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAO5mz2YC/x2N0QqDMAxFf0XyvIArxbn9ytiDq9EGalMS3QTx3
 1f2eOCeew4wUiaDR3OA0oeNJVe4XhoIccgzIY+VwbXOt73rMX4XySh7QaNsooYT7xhS3SIvJXH
 gFachpTWqbHPEd0f3m3c++G6EeluUqvFPPl/n+QMg9+WyggAAAA==
To: Derek John Clark <derekjohn.clark@gmail.com>, 
 =?utf-8?q?Joaqu=C3=ADn_Ignacio_Aramend=C3=ADa?= <samsagax@gmail.com>, 
 Jean Delvare <jdelvare@suse.com>, Guenter Roeck <linux@roeck-us.net>
Cc: linux-hwmon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2096; i=nathan@kernel.org;
 h=from:subject:message-id; bh=xfR7DLMbJuXnyQugqbUW1ndOSxrOfW6eObhJ/3J9Tf4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGnn0xluL4tfI7nldhTHowp3+Q2LDbQCrmnOvLh82y8eC
 4vetwyCHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAi+9QYGfZ9/zRtbqLfk0OT
 4pP2fN/Mbv5D0bdTt+9vfvEPh2v3r/9nZPg8428Ti42l9cTnEjtmHNYS75zWrJe8yerfbyeDdSl
 v0tkA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

clang warns (or errors due to CONFIG_WERROR):

  drivers/hwmon/oxp-sensors.c:481:3: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
  drivers/hwmon/oxp-sensors.c:553:3: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
  drivers/hwmon/oxp-sensors.c:556:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
  drivers/hwmon/oxp-sensors.c:607:3: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]

Clang is a little more pedantic than GCC, which does not warn when
falling through to a case that is just break or return. Clang's version
is more in line with the kernel's own stance in deprecated.rst, which
states that all switch/case blocks must end in either break,
fallthrough, continue, goto, or return. Add the missing breaks to
silence the warnings.

Fixes: b82b38a49926 ("hwmon: (oxp-sensors) Add support for multiple new devices.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/hwmon/oxp-sensors.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hwmon/oxp-sensors.c b/drivers/hwmon/oxp-sensors.c
index b6d06370469d..83730d931824 100644
--- a/drivers/hwmon/oxp-sensors.c
+++ b/drivers/hwmon/oxp-sensors.c
@@ -478,6 +478,7 @@ static int oxp_platform_read(struct device *dev, enum hwmon_sensor_types type,
 			default:
 				break;
 			}
+			break;
 		default:
 			break;
 		}
@@ -550,9 +551,11 @@ static int oxp_platform_read(struct device *dev, enum hwmon_sensor_types type,
 			default:
 				break;
 			}
+			break;
 		default:
 			break;
 		}
+		break;
 	default:
 		break;
 	}
@@ -604,6 +607,7 @@ static int oxp_platform_write(struct device *dev, enum hwmon_sensor_types type,
 			default:
 				break;
 			}
+			break;
 		default:
 			break;
 		}

---
base-commit: ebb75a3c5265ceeebd2b0708d013735e5eafbb69
change-id: 20240828-hwmon-oxp-sensors-fix-clang-implicit-fallthrough-b6e97424c46d

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

