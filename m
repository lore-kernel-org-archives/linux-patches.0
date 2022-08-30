Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CFF6134
	for <patches@lists.linux.dev>; Tue, 30 Aug 2022 22:58:34 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id i7-20020a17090adc0700b001fd7ccbec3cso2464620pjv.0
        for <patches@lists.linux.dev>; Tue, 30 Aug 2022 15:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=19gKfO2YDbR1tWt1JPXALLMo6GyTndA+o+AoPOLFBAs=;
        b=cuBC6/5JrePt4mhJwmjB8G1ozut0+vlf2xAHpQSwWj9zRxbFHMMhFKL/8Qv5I0z9Ec
         mIhgGk99Tpt9MXjTxh2SvzCAvuyLxzK9AL8lkILTWZc1hZLy4RbiFwPW8P7qPTOjDa9N
         FCon6w5dPmosnUNTDoa2i7YYBPM0403jlqK3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=19gKfO2YDbR1tWt1JPXALLMo6GyTndA+o+AoPOLFBAs=;
        b=nkkX/kE3SLmS/3ag16HNlI0lmHt779xeY9BOWU8LBVSwMMrRCu6BdT1+sFPJ94JJgs
         4fiaY9nbmbuGu456uGizvNwv0OhLwlnsB8V3GOCaCxjgl5J16HBDBKgEiQlMB4PYAT31
         W/pq52qHXsBdgkkJ2diW6BUiMEIVrK9GYSGUhxK6xnl+SC1gpqsct6z9iZb00yuQ1LNW
         N62C1tuHAuNyG+X9nQohobhoOVxK/LgZrXgsXNoFAHdwkM2EkWuZ7OvMrZVU5IjOt7qz
         LxoP9sLJHr6D4QX74di3lDGB8kOAlD1zxRYuzGRzaaZpP53rG8D4q9kO2dhQsE86FJd+
         IE+g==
X-Gm-Message-State: ACgBeo2CoajyyUW6SarTz1dQQZKhLCtgFpsTlzixbOmWs4qyLSJUV0YC
	BbVF0z3UgxQTZqVHvIijbX3lqg==
X-Google-Smtp-Source: AA6agR7FX/ULITnzjbZuJ8dxIpYtuHEfPjEMHXQv0zaQxxGVpiyL6dIVjMuXdVDc3x962k1HOIh3jg==
X-Received: by 2002:a17:902:db05:b0:172:f759:f99d with SMTP id m5-20020a170902db0500b00172f759f99dmr23137940plx.76.1661900313631;
        Tue, 30 Aug 2022 15:58:33 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:5f34:2f6:2856:188e])
        by smtp.gmail.com with ESMTPSA id bf3-20020a170902b90300b001743be790b4sm10083539plb.215.2022.08.30.15.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 15:58:33 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Prashant Malani <pmalani@chromium.org>,
	Benson Leung <bleung@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 0/4] platform/chrome: Minor cleanups to cros_typec_switch
Date: Tue, 30 Aug 2022 15:58:27 -0700
Message-Id: <20220830225831.2362403-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A small cleanup patch pile for the new cros_typec_switch driver.

Stephen Boyd (4):
  platform/chrome: cros_typec_switch: Add missing newline on printk
  platform/chrome: cros_typec_switch: Remove impossible condition
  platform/chrome: cros_typec_switch: Use PTR_ERR_OR_ZERO() to simplify
  platform/chrome: cros_typec_switch: Inline DRV_NAME

 drivers/platform/chrome/cros_typec_switch.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)


base-commit: 1a8912caba02522f612d465a4849ce98915b96ad
-- 
https://chromeos.dev

