Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27BC38F92F
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 21:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789335266; cv=none; b=EtOI8XAv55PwK19VHlHhr7WcNaRroS8ijGXD/NrFb0acDZhrBKeUcvGS1KLaX35Su50htBCJGxckfKlFyS3LlcvwTLkwGbO3LFBMYfNAvWh2YquSQkJU53VVnsI9+KKuPmhj4JfXeaZLvrqXgKL8TBiKj/cAO2+gP9plLhmCXOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789335266; c=relaxed/simple;
	bh=SVzMcetM1Ujko8uhq5KDuC5TeNGrM/6zHHBVgzQIpxg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uQGplc8sW19FKAT5GjyLM5B76MNCYnP2SHvTBldNOzZnCQCPWJNr8PHsJiR9Pm123Tx65/6Qk83WrRQI7Sq4x80eWMPk5ePBLZvuvZoyoOHbtoYOsBDeqsut8xplAi1ai8ciJra/qkGGZvpJibUDjD7I3GdZSpF+rDLv3QvOoL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NtUq+qqe; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NtUq+qqe"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49ccfae359fso19163085e9.3
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 14:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789335260; x=1789940060; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SVzMcetM1Ujko8uhq5KDuC5TeNGrM/6zHHBVgzQIpxg=;
        b=NtUq+qqeoAyMLG+gPkJ1uhqQpg3oe7dRIFwqXTxKpMJ+sc3bq7q75Uy5/oU4hUBNh2
         VYC/TZOfM8c7CSnr0qpwKRxJNT1Ek00QLd3WWcXsbBZl7vkhULaG19PY8VIxEoH8SR4i
         w7tiPI6pf59+lKTH8lIp38M1/SxVf6UOLn/jwrA7ipfcyS8xaja4w0OOI+2dUdq72WiL
         FR9JH9gqKWwp/sjX2Fsnv1ROu7OUdTtmOODrvLULlarruCZi3DLaQXWjJ1rqBdqlfsZl
         51faqX6Gc/D6toQqQZgNhDAYAB9azMI3P6RW3Kl987wg+djDSHWoNwxJ9OMLqPjicdMs
         gN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789335260; x=1789940060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SVzMcetM1Ujko8uhq5KDuC5TeNGrM/6zHHBVgzQIpxg=;
        b=SWluwQpD8kkGEaQNi6uWBhG7DB2am7fYpROoH3W8++JTIw6dLVMLZJC+rI8c35m6ul
         9+IJQIbbHgh6c9Yi/d99Tu5GEtChtONh2uqi05RP9g6xFJUFQ+lTyxGP3or+RkhvggD1
         mJsiB1lB4/ezPuUH48EeXMRreV2WT7uCuNkY0JYFXULTvbs+5CpHs+Iq6fYmCQpF5OWm
         Uih9DnrcUq6gRkRIsvfk6rCDt3UIElm4zS6cCBygYdhrN6juJZckfYmehQgU6VM9L78l
         iaQI9+a9uQiZmHnM4O5ncdPxGxBVToIkQ2tQyBI5bFOaEFgIoD3I0EYGbjTFluPwa8P4
         NNlw==
X-Forwarded-Encrypted: i=1; AKwUvBx5VTB1EERpFkRf+1WNL1LMHKoEEOj1YyxnZtQdrdhsoeS014fdcODZGGk6cwMa4g0YTZ7BmkA5@lists.linux.dev
X-Gm-Message-State: AFuF++k1FcSejhRY9LX4VKwquLoB7AnYy7cvmzPxh/KPBbHdmbZKfZID
	e9oLYD2lkwVfFH+9Yxxb6++k0X53GJTo79K1WpYz4klHwjUHajF5qRDA
X-Gm-Gg: AYBFou1k+EOveLGEmsDb/DmECFlDLNf6ERdyxpbmCAG2t43WqzzEYk8CHmDazIJgnv3
	n4WR95LF8h3mSqedRN03EIel4AIa3pWUO9hltMVufjZw7bVJrjk12grdI6CuxWjSQFmvzJW34wS
	ZbxSfrPppiwga8umRzCk4CDyTLse0C902B3gDCn0DiaQ0v/QK+dm9HmO/22P0TK+CupQ58IHPvn
	3w0MUI8QrYkVI1FXqr3RhpEnrQspOp9orFVeWHcPlAE+JUQvM3v9UKNlu+FTBoCMe3WGQrRAq7/
	ytIxzui0q5ezpo3JaHlVJ+MFkbyxFJapfL3yew7gEU6wXW7kr+iwUT1HWc9b7X/1wubOC+tccPS
	WkLwWvrJYjmeHW9PveYFxQKWbcS9FsYMilxlRGA/ZSUzHLQ7NInjRKQHYPwK9+INI2W+jmAXua3
	r37x3uS1bwaCnh9BpCy/gNmbvGl+XDyCkU8ghXdVe2jN6nqrW7eL4dXv+GsM2ld2/9gwZfoLHjO
	vKcqLHK4jYo0FMxBumcDYN6+sbM4jnai+EFpklHuXxwar7l1iSM9GKfTGWepHeUw8ToKrTd0GTV
	B6j6kakyi0y8MCjkqz61izxvmet1aSKEOabLUZ6epS2ZGwKgLVuRUbnZYYzL47PNH1DGvIlkgsp
	xfZSkc/dEKgjv
X-Received: by 2002:a05:600c:1392:b0:49e:799a:8969 with SMTP id 5b1f17b1804b1-49e799a8b98mr3099465e9.30.1789335260395;
        Sun, 13 Sep 2026 14:34:20 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0e6-2301-7846-2cfb-35f5-6359.310.pool.telefonica.de. [2a02:3100:a0e6:2301:7846:2cfb:35f5:6359])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e62cffaa0sm103932975e9.0.2026.09.13.14.34.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 14:34:19 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Ritesh Harjani <riteshh@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 712/798] tracing: Have TRACE_DEFINE_ENUM affect trace event types as well
Date: Sun, 13 Sep 2026 23:34:14 +0200
Message-Id: <20260913213414.5425-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260912065533.404747135@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org> <20260912065533.404747135@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please hold this patch unless an adapted 5.10 backport of upstream commit
795301d3c289 ("tracing: Have type enum modifications copy the strings")
can also be included.

This backport passes a pointer into the const field->type string to
eval_replace(), which writes the numeric enum value through that pointer.

I reproduced this on the exact 5.10.270-rc1 tip
f69aa74a82509ee94a2aac2822b4189496f267a8 in s390x QEMU. During normal
trace initialization, the built-in ext4_fc_stats event caused a
write-protection fault in eval_replace() before userspace started, followed
by an Oops and panic.

With an adapted 795301d3c289 applied, the same kernel booted without an
Oops and the live ext4 event format contained the expected numeric array
bound, fc_ineligible_rc[11].

Thanks,
Karl
