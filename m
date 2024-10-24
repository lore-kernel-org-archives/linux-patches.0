Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA10D2003DF
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793392; cv=none; b=MWwa6fZUD8+3chfQWibtvtBYG3GefbZeXVLnfcjV2wXbU3p/B8aZ6Yx8rGG7zROyDGb6BwZXgnNqbcH/MHEEoQeB1RcPrKcgF+g7TWJUUzn9F2rA67PoPphhxz94iJPaNzIKZ+sJhJ9E+3byOHH/nX9CiUUrO/WzIOaHQNJDjFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793392; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ch+cUnswshMN5vBFgjebP7vCiR1fO1jDbX6kiwmXwS3gbpSybkbqlwB9hKoKBGjxR+TWQXBOd+2t/Yv1FcjBIhuLrF+zAZlT8kKLkF9MDzCzQ2f6vfJ+OenqKHfD3JY9uZSW3f+Ntx79E1vy2CJlBZNwagcDQIzGyOb+1NR1CSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lh1YWO9w; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lh1YWO9w"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539e3f35268so1550243e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793388; x=1730398188; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=lh1YWO9wkisIt2xiF/Wk9OtQWfOU563TJgkVGcMKdEvc3HRJTlwmBoFDXA3sw+mmXV
         0qiu8sAawZ/8SfsllIS6bNysWx2s0mBsl9IJhnk8qHNhphPAKW+v42FLlCFktJug70cP
         k3Z9DGU3xunY/jAFLETcUcpFBGUjV2w4Dd01RHh2Py2o2qoqdErJyPR3dRqkeIZwLZNg
         DvKTNqo5U+NwGQKxexVEaZfXmKnws4PgBmhdbQHpyrUM4GE6WMeolp+M9VzDKqryE3XV
         VYdJ2XmVvsvl+nOAZl7WHCFHE4RkLg7r2yOIy7Q5GEJvRDnhpxSTovuW+CU25yh6WkkA
         CDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793388; x=1730398188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=ENLbWQUJ58DI4wx3hPkuEiPEjOGVt45LGuiqM7sX1PQCd0zR6SoThVc29Kr7PLZwsm
         q6YMs1fWX8uQVo5/zN7aHaVxsJaQOkSWko2CinAqIE9Ms04ukGdG/QxLE1O73u6tlzw1
         vyBYp1LzI9dmz4L4a2EWzuPG/0cUXeXlqZt299amzPI9skqtDDPhgnp3EYIApQjXzfUL
         hvW0OODLwaNdEGPTMGwIMKpUrjIQViKE/uRbaPcR+Ej9GQKG9LuBCdWcynJOKEaeWJ6K
         xM6ufAFfJ4SvqjqQ2YVJAEz82TLq+wIjZwEhHP4cLuEFmJxX4tkxfZ3FEtWEggeDJ1EN
         Poig==
X-Gm-Message-State: AOJu0Yy0ChHMOrjjcbygVr6sdvrwt6YM29e72FDktfk0QIvucnVUHmoj
	TPNFSizd0E8ceBQ8vxqWomQ+NlSWRmDSnBGm5PWbr/LQ34wNCR/X
X-Google-Smtp-Source: AGHT+IF3WAShwREMyEIE7xh3tuwaZh8wdtfaT//VG6hqi3j/n0ccwihbcicFMzqDPWq/alXsz11zLg==
X-Received: by 2002:a05:6512:108b:b0:539:8d9b:b624 with SMTP id 2adb3069b0e04-53b1a373b05mr4570149e87.55.1729793387728;
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b1f7a9d2bsm454426e87.193.2024.10.24.11.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:42 +0300
Message-ID: <20241024180942.3604-1-vladimirputin693389@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
References: <2024101835-tiptop-blip-09ed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

You should kill yourself NOW!
